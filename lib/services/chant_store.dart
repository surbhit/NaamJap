import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';
import '../models/chant_models.dart';

class SignInResult {
  const SignInResult({required this.ok, this.message});

  final bool ok;
  final String? message;
}

/// Mantras, targets, the open chanting session, and completed history.
///
/// Signed-in data is the mobile app's Cloud Firestore tree:
/// `users/{uid}` plus `users/{uid}/mantras/{id}`.
class ChantStore extends ChangeNotifier {
  static const guestKey = 'naamjap.chant.v1';

  bool ready = false;
  bool syncing = false;
  String? syncError;
  User? user;

  List<Mantra> mantras = defaultMantras();
  List<ChantHistoryEntry> history = [];
  String activeMantraId = 'gan-ganapataye';
  int sessionChants = 0;
  DateTime? sessionStartedAt;

  StreamSubscription<User?>? _authSub;
  Future<void> _queue = Future<void>.value();
  Timer? _remoteTimer;
  int _authGen = 0;
  bool _disposed = false;
  int? _accountTarget;
  bool _targetDirty = false;
  int _unsyncedSeconds = 0;
  final Map<String, int> _syncedCounts = {};
  final Map<String, int> _beadsById = {};
  final Set<String> _removedIds = {};

  Mantra get active {
    for (final mantra in mantras) {
      if (mantra.id == activeMantraId) return mantra;
    }
    return mantras.first;
  }

  Duration get elapsed {
    final started = sessionStartedAt;
    if (started == null || sessionChants == 0) return Duration.zero;
    return DateTime.now().difference(started);
  }

  bool get firebaseReady => Firebase.apps.isNotEmpty;

  Future<void> load() async {
    await _loadFromPrefs(guestKey, useDefaultsWhenMissing: true);
    ready = true;
    notifyListeners();
    _listenAuth();
  }

  void _listenAuth() {
    if (!firebaseReady) return;
    if (DefaultFirebaseOptions.web.projectId == 'your-project-id') return;
    _authSub = FirebaseAuth.instance.authStateChanges().listen(
      _onAuthUser,
      onError: (Object error) {
        syncError = _readableError(error);
        notifyListeners();
      },
    );
  }

  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  Future<void> _onAuthUser(User? next) async {
    final gen = ++_authGen;
    user = next;
    if (next == null) {
      await _loadFromPrefs(guestKey, useDefaultsWhenMissing: true);
      if (gen != _authGen) return;
      syncing = false;
      notifyListeners();
      return;
    }

    syncing = true;
    syncError = null;
    notifyListeners();
    try {
      await _pullAndMerge(next);
    } catch (error) {
      syncError = _readableError(error);
      await _loadFromPrefs(_userKey(next.uid), useDefaultsWhenMissing: false);
    }
    if (gen != _authGen) return;
    syncing = false;
    notifyListeners();
  }

  void chant() {
    final mantra = active;
    if (sessionStartedAt == null || sessionChants == 0) {
      sessionStartedAt = DateTime.now();
    }
    mantra.totalChants += 1;
    sessionChants += 1;
    notifyListeners();
    _enqueueSave();
  }

  Future<void> finishSession() async {
    if (sessionChants <= 0) return;
    _recordHistory();
    sessionChants = 0;
    sessionStartedAt = null;
    notifyListeners();
    await flush();
  }

  void selectMantra(String id) {
    if (id == activeMantraId) return;
    if (!mantras.any((mantra) => mantra.id == id)) return;
    if (sessionChants > 0) {
      _recordHistory();
      sessionChants = 0;
      sessionStartedAt = null;
    }
    activeMantraId = id;
    notifyListeners();
    _enqueueSave();
  }

  void addMantra({
    required String name,
    String detail = '',
    int target = defaultMantraTarget,
  }) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final mantra = Mantra(
      id: 'mantra-${DateTime.now().microsecondsSinceEpoch}',
      name: trimmed,
      detail: detail.trim(),
      target: target < 1 ? defaultMantraTarget : target,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    mantras = [...mantras, mantra];
    selectMantra(mantra.id);
  }

  void setTarget(String id, int target) {
    if (target < 1) return;
    for (final mantra in mantras) {
      if (mantra.id == id) {
        mantra.target = target;
        _accountTarget = target;
        _targetDirty = true;
        notifyListeners();
        _enqueueSave();
        return;
      }
    }
  }

  void removeMantra(String id) {
    if (mantras.length <= 1) return;
    if (sessionChants > 0 && activeMantraId == id) {
      _recordHistory();
      sessionChants = 0;
      sessionStartedAt = null;
    }
    mantras = mantras.where((mantra) => mantra.id != id).toList();
    if (_syncedCounts.containsKey(id)) _removedIds.add(id);
    _syncedCounts.remove(id);
    _beadsById.remove(id);
    if (activeMantraId == id) {
      activeMantraId = mantras.first.id;
    }
    notifyListeners();
    _enqueueSave();
  }

  Future<SignInResult> signIn() async {
    if (DefaultFirebaseOptions.web.projectId == 'your-project-id') {
      return const SignInResult(
        ok: false,
        message:
            'Google sign-in still needs the Firebase web config. Add it in lib/firebase_options.dart, enable Google as a sign-in provider, and allow www.ramchandrasolutions.com.',
      );
    }
    if (!kIsWeb) {
      return const SignInResult(
        ok: false,
        message: 'Google sign-in is available on the website.',
      );
    }
    try {
      final provider =
          GoogleAuthProvider()
            ..addScope('email')
            ..addScope('profile');
      await FirebaseAuth.instance.signInWithPopup(provider);
      return const SignInResult(ok: true);
    } catch (error) {
      final message = _readableError(error);
      if (message == null) return const SignInResult(ok: false);
      return SignInResult(ok: false, message: message);
    }
  }

  Future<void> signOut() async {
    if (!firebaseReady) return;
    await FirebaseAuth.instance.signOut();
  }

  Future<void> flush() {
    _remoteTimer?.cancel();
    _queue = _queue.then((_) => _writeLocal()).then((_) => _pushRemote());
    return _queue;
  }

  void _recordHistory() {
    final started = sessionStartedAt ?? DateTime.now();
    final ended = DateTime.now();
    history = [
      ...history,
      ChantHistoryEntry(
        id: 'h-${ended.microsecondsSinceEpoch}',
        mantraId: active.id,
        mantraName: active.name,
        chants: sessionChants,
        startedAt: started,
        endedAt: ended,
      ),
    ];
    if (user != null) {
      _unsyncedSeconds += ended.difference(started).inSeconds;
    }
  }

  void _enqueueSave() {
    _queue = _queue.then((_) => _writeLocal());
    if (user == null) return;
    _remoteTimer?.cancel();
    _remoteTimer = Timer(const Duration(milliseconds: 700), () {
      _queue = _queue.then((_) => _pushRemote());
    });
  }

  String _userKey(String uid) => 'naamjap.chant.$uid';

  Future<void> _writeLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final key = user == null ? guestKey : _userKey(user!.uid);
    await prefs.setString(key, jsonEncode(_snapshot()));
    if (user == null) return;
    // Keep the guest copy untouched. The signed-in cache is the key above.
  }

  Map<String, dynamic> _snapshot() {
    return {
      'activeMantraId': activeMantraId,
      'sessionChants': sessionChants,
      'sessionStartedAt': sessionStartedAt?.millisecondsSinceEpoch,
      'mantras': {for (final mantra in mantras) mantra.id: mantra.toJson()},
      'history': {for (final entry in history) entry.id: entry.toJson()},
    };
  }

  Future<void> _loadFromPrefs(
    String key, {
    required bool useDefaultsWhenMissing,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) {
      if (useDefaultsWhenMissing) _applyDefaults();
      return;
    }
    try {
      _applySnapshot(jsonDecode(raw));
    } catch (_) {
      if (useDefaultsWhenMissing) _applyDefaults();
    }
  }

  void _applyDefaults() {
    mantras = defaultMantras();
    history = [];
    activeMantraId = mantras.first.id;
    sessionChants = 0;
    sessionStartedAt = null;
  }

  void _applySnapshot(dynamic raw) {
    final data = asStringMap(raw);
    final parsedMantras = _mantrasFrom(data['mantras']);
    if (parsedMantras.isEmpty) {
      _applyDefaults();
      return;
    }
    mantras = parsedMantras;
    history = _historyFrom(data['history']);
    final requested = (data['activeMantraId'] ?? '').toString();
    activeMantraId =
        mantras.any((mantra) => mantra.id == requested)
            ? requested
            : mantras.first.id;
    sessionChants = asInt(data['sessionChants']);
    final started = asInt(data['sessionStartedAt']);
    sessionStartedAt =
        sessionChants > 0 && started > 0
            ? DateTime.fromMillisecondsSinceEpoch(started)
            : null;
    final session = asStringMap(data['session']);
    if (session.isNotEmpty && sessionChants == 0) {
      sessionChants = asInt(session['chants']);
      final sessionStart = asInt(session['startedAt']);
      sessionStartedAt =
          sessionChants > 0 && sessionStart > 0
              ? DateTime.fromMillisecondsSinceEpoch(sessionStart)
              : null;
      final sessionMantra = (session['mantraId'] ?? '').toString();
      if (mantras.any((mantra) => mantra.id == sessionMantra)) {
        activeMantraId = sessionMantra;
      }
    }
  }

  List<Mantra> _mantrasFrom(dynamic raw) {
    final map = asStringMap(raw);
    final list = <Mantra>[];
    map.forEach((id, value) {
      final json = asStringMap(value);
      if (json.isEmpty) return;
      list.add(Mantra.fromJson(id, json));
    });
    list.sort((a, b) {
      final byTime = a.createdAt.compareTo(b.createdAt);
      if (byTime != 0) return byTime;
      return a.name.compareTo(b.name);
    });
    return list;
  }

  List<ChantHistoryEntry> _historyFrom(dynamic raw) {
    final map = asStringMap(raw);
    final list = <ChantHistoryEntry>[];
    map.forEach((id, value) {
      final json = asStringMap(value);
      if (json.isEmpty) return;
      list.add(ChantHistoryEntry.fromJson(id, json));
    });
    list.sort((a, b) => a.endedAt.compareTo(b.endedAt));
    return list;
  }

  Future<void> _pullAndMerge(User signedIn) async {
    final guestMantras = mantras.map((mantra) => mantra.copy()).toList();
    final guestHistory = List<ChantHistoryEntry>.from(history);
    final guestSessionChants = sessionChants;
    final guestSessionStart = sessionStartedAt;
    final guestActive = activeMantraId;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(signedIn.uid);
    final userSnap = await userRef.get();
    final mantraSnap = await userRef.collection('mantras').get();
    if (!userSnap.exists && mantraSnap.docs.isEmpty) {
      await _pushRemote(profileUser: signedIn);
      await _writeLocal();
      return;
    }

    final userData = userSnap.data() ?? {};
    final accountTarget = asInt(userData['user_target']);
    _accountTarget = accountTarget > 0 ? accountTarget : null;
    final goal = accountTarget > 0 ? accountTarget : defaultMantraTarget;
    final userDaily = _intMap(userData['history']);

    _syncedCounts.clear();
    _beadsById.clear();
    final remoteMantras = <Mantra>[];
    final remoteDaily = <String, Map<String, int>>{};
    for (final doc in mantraSnap.docs) {
      final data = doc.data();
      final count = asInt(data['count']);
      final beads = asInt(data['targetCount'], beadsPerMala);
      final created = int.tryParse(doc.id) ?? 0;
      remoteMantras.add(
        Mantra(
          id: doc.id,
          name: (data['name'] ?? 'Mantra').toString(),
          totalChants: count,
          target: goal,
          createdAt: created > 0 ? created : doc.id.hashCode,
        ),
      );
      _syncedCounts[doc.id] = count;
      _beadsById[doc.id] = beads > 0 ? beads : beadsPerMala;
      remoteDaily[doc.id] = _intMap(data['history']);
    }

    if (remoteMantras.isEmpty) {
      await _pushRemote(profileUser: signedIn);
      await _writeLocal();
      return;
    }

    final busiestId =
        remoteMantras
            .reduce(
              (best, mantra) =>
                  mantra.totalChants > best.totalChants ? mantra : best,
            )
            .id;
    if ((remoteDaily[busiestId] ?? {}).isEmpty && userDaily.isNotEmpty) {
      remoteDaily[busiestId] = userDaily;
    }

    final keptGuestHistory = <ChantHistoryEntry>[];
    for (final guest in guestMantras) {
      if (guest.totalChants <= 0) continue;
      final match = _findByName(remoteMantras, guest.name);
      if (match != null) {
        match.totalChants += guest.totalChants;
        keptGuestHistory.addAll(
          guestHistory.where((entry) => entry.mantraId == guest.id),
        );
        continue;
      }
      remoteMantras.add(guest.copy()..target = goal);
      _beadsById[guest.id] = beadsPerMala;
      keptGuestHistory.addAll(
        guestHistory.where((entry) => entry.mantraId == guest.id),
      );
    }

    remoteMantras.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    mantras = remoteMantras;
    history = [..._dayEntries(remoteDaily), ...keptGuestHistory]
      ..sort((a, b) => a.endedAt.compareTo(b.endedAt));

    sessionChants = guestSessionChants;
    sessionStartedAt = guestSessionChants > 0 ? guestSessionStart : null;
    final guestActiveMantra = _findById(guestMantras, guestActive);
    if (guestActiveMantra != null) {
      final match = _findByName(mantras, guestActiveMantra.name);
      if (match != null) activeMantraId = match.id;
    }
    if (!mantras.any((mantra) => mantra.id == activeMantraId)) {
      activeMantraId = mantras.first.id;
    }

    await _pushRemote(profileUser: signedIn);
    await _writeLocal();
  }

  List<ChantHistoryEntry> _dayEntries(Map<String, Map<String, int>> daily) {
    final entries = <ChantHistoryEntry>[];
    daily.forEach((mantraId, days) {
      final mantra = _findById(mantras, mantraId);
      final name = mantra?.name ?? '';
      days.forEach((day, chants) {
        if (chants <= 0) return;
        final when = DateTime.tryParse(day) ?? DateTime.now();
        entries.add(
          ChantHistoryEntry(
            id: 'day-$mantraId-$day',
            mantraId: mantraId,
            mantraName: name,
            chants: chants,
            startedAt: when,
            endedAt: when,
          ),
        );
      });
    });
    return entries;
  }

  Mantra? _findById(Iterable<Mantra> list, String id) {
    for (final mantra in list) {
      if (mantra.id == id) return mantra;
    }
    return null;
  }

  Mantra? _findByName(Iterable<Mantra> list, String name) {
    final key = name.trim().toLowerCase();
    for (final mantra in list) {
      if (mantra.name.trim().toLowerCase() == key) return mantra;
    }
    return null;
  }

  Map<String, int> _intMap(dynamic raw) {
    final map = asStringMap(raw);
    return {
      for (final entry in map.entries)
        if (asInt(entry.value) > 0) entry.key: asInt(entry.value),
    };
  }

  String _todayKey() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }

  Future<void> _pushRemote({User? profileUser}) async {
    final signedIn = profileUser ?? user;
    if (signedIn == null || !firebaseReady) return;
    if (DefaultFirebaseOptions.web.projectId == 'your-project-id') return;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(signedIn.uid);
    final today = _todayKey();
    final seconds = _unsyncedSeconds;
    final removed = _removedIds.toList();
    final pending = [
      for (final mantra in mantras)
        if (_mantraNeedsPush(mantra, seconds)) mantra,
    ];
    if (pending.isEmpty && removed.isEmpty && !_targetDirty) return;

    await FirebaseFirestore.instance.runTransaction((tx) async {
      final userSnap = await tx.get(userRef);
      final userData = userSnap.data() ?? {};
      final mantraSnaps = <String, DocumentSnapshot<Map<String, dynamic>>>{};
      for (final mantra in pending) {
        mantraSnaps[mantra.id] = await tx.get(
          userRef.collection('mantras').doc(mantra.id),
        );
      }

      var addedChants = 0;
      var addedMalas = 0;
      for (final mantra in pending) {
        final snap = mantraSnaps[mantra.id]!;
        final data = snap.data() ?? {};
        final remoteCount = asInt(data['count']);
        final beads =
            _beadsById[mantra.id] ??
            (asInt(data['targetCount']) > 0
                ? asInt(data['targetCount'])
                : beadsPerMala);
        final baseline =
            _syncedCounts[mantra.id] ?? (snap.exists ? remoteCount : 0);
        final added = mantra.totalChants - baseline;
        final nextCount = remoteCount + (added > 0 ? added : 0);
        final history = _intMap(data['history']);
        if (added > 0) history[today] = (history[today] ?? 0) + added;
        final timeHistory = _intMap(data['timeHistory']);
        if (seconds > 0 && mantra.id == activeMantraId) {
          timeHistory[today] = (timeHistory[today] ?? 0) + seconds;
        }
        tx.set(userRef.collection('mantras').doc(mantra.id), {
          'id': mantra.id,
          'name': mantra.name,
          'count': nextCount,
          'malaCount': nextCount ~/ beads,
          'targetCount': beads,
          'history': history,
          'timeHistory': timeHistory,
          if (added > 0) 'lastChanted': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        if (added > 0) {
          addedChants += added;
          addedMalas += nextCount ~/ beads - remoteCount ~/ beads;
        }
        _beadsById[mantra.id] = beads;
      }

      for (final id in removed) {
        tx.delete(userRef.collection('mantras').doc(id));
      }

      final history = _intMap(userData['history']);
      final timeHistory = _intMap(userData['time_history']);
      if (addedChants > 0) {
        history[today] = (history[today] ?? 0) + addedChants;
      }
      if (seconds > 0) {
        timeHistory[today] = (timeHistory[today] ?? 0) + seconds;
      }
      final totalCount = asInt(userData['total_count']) + addedChants;
      final totalMalas = asInt(userData['total_malas']) + addedMalas;
      final target = _accountTarget ?? (userSnap.exists ? null : active.target);
      tx.set(userRef, {
        'displayName': signedIn.displayName ?? '',
        'email': signedIn.email ?? '',
        'photoURL': signedIn.photoURL ?? '',
        if (target != null) 'user_target': target,
        'mantra_count': mantras.length,
        if (addedChants > 0) 'total_count': totalCount < 0 ? 0 : totalCount,
        if (addedMalas != 0) 'total_malas': totalMalas < 0 ? 0 : totalMalas,
        if (addedChants > 0) 'history': history,
        if (seconds > 0) 'time_history': timeHistory,
        'updatedAt': FieldValue.serverTimestamp(),
        'lastSynced': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });

    for (final mantra in mantras) {
      _syncedCounts[mantra.id] = mantra.totalChants;
    }
    _removedIds.removeAll(removed);
    _targetDirty = false;
    _unsyncedSeconds = (_unsyncedSeconds - seconds).clamp(0, 86400 * 365);
  }

  bool _mantraNeedsPush(Mantra mantra, int seconds) {
    final baseline = _syncedCounts[mantra.id];
    if (baseline == null) return mantra.totalChants > 0;
    if (mantra.totalChants > baseline) return true;
    return seconds > 0 && mantra.id == activeMantraId;
  }

  String? _readableError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'popup-closed-by-user':
        case 'cancelled-popup-request':
          return null;
        case 'unauthorized-domain':
          return 'This site is not an authorized domain in Firebase Authentication yet.';
        case 'operation-not-allowed':
          return 'Enable Google as a sign-in provider in Firebase Authentication.';
        case 'invalid-api-key':
        case 'api-key-not-valid':
          return 'The Firebase web API key in this build is not valid.';
        default:
          return error.message ?? 'Google sign-in failed.';
      }
    }
    if (error is FirebaseException) {
      if (error.code == 'permission-denied') {
        return 'Firebase denied access to this account. Check the database rules for users/{uid}.';
      }
      return error.message ?? 'Could not sync your chanting data.';
    }
    return 'Could not sync your chanting data.';
  }

  @override
  void dispose() {
    _disposed = true;
    _remoteTimer?.cancel();
    _authSub?.cancel();
    super.dispose();
  }
}
