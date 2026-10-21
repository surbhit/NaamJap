import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/chant_models.dart';
import '../services/chant_store.dart';
import '../widgets/chant_chrome.dart';
import '../widgets/mala_counter.dart';
import 'journey_screen.dart';
import 'mantras_screen.dart';

class ChantScreen extends StatefulWidget {
  const ChantScreen({super.key});

  @override
  State<ChantScreen> createState() => _ChantScreenState();
}

class _ChantScreenState extends State<ChantScreen>
    with WidgetsBindingObserver {
  final ChantStore _store = ChantStore();
  Timer? _ticker;
  double _pulse = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _store.addListener(_onStore);
    _store.load();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _store.sessionChants == 0) return;
      setState(() {});
    });
  }

  void _onStore() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive) {
      _store.flush();
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _store.removeListener(_onStore);
    _store.flush();
    _store.dispose();
    super.dispose();
  }

  Future<void> _chant() async {
    _store.chant();
    HapticFeedback.lightImpact();
    setState(() => _pulse = 1.06);
    await Future<void>.delayed(const Duration(milliseconds: 90));
    if (mounted) setState(() => _pulse = 1);
  }

  Future<void> _done() async {
    if (_store.sessionChants == 0) return;
    await _store.finishSession();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Session saved'),
        backgroundColor: chantBrown,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _signIn() async {
    final result = await _store.signIn();
    if (!mounted || result.ok || result.message == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result.message!)),
    );
  }

  void _openMantras() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MantrasScreen(store: _store),
      ),
    );
  }

  void _openJourney() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => JourneyScreen(store: _store),
      ),
    );
  }

  Future<void> _openAccount() async {
    if (_store.user == null) {
      await _signIn();
      return;
    }
    if (!mounted) return;
    final user = _store.user!;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFFFFF3E0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: chantBrown.withValues(alpha: 0.15),
                  backgroundImage: user.photoURL == null
                      ? null
                      : NetworkImage(user.photoURL!),
                  child: user.photoURL == null
                      ? Text(
                          (user.displayName ?? user.email ?? 'U')
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                            color: chantBrown,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 10),
                Text(
                  user.displayName?.isNotEmpty == true
                      ? user.displayName!
                      : 'Signed in',
                  style: const TextStyle(
                    color: chantBrown,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (user.email != null)
                  Text(
                    user.email!,
                    style: const TextStyle(color: chantBrownSoft),
                  ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.insights_outlined, color: chantBrown),
                  title: const Text(
                    'Your Journey',
                    style: TextStyle(color: chantBrown, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _openJourney();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: chantBrown),
                  title: const Text(
                    'Sign out',
                    style: TextStyle(color: chantBrown, fontWeight: FontWeight.w600),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await _store.signOut();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChantScaffold(
      child: Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        },
        child: Actions(
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                _chant();
                return null;
              },
            ),
          },
          child: Focus(
            autofocus: true,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = math.min(480.0, constraints.maxWidth);
                return Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: width,
                    height: constraints.maxHeight,
                    child: SafeArea(child: _buildBody(constraints.maxHeight)),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(double height) {
    final mantra = _store.mantras.isEmpty ? null : _store.active;
    final compact = height < 700;
    final titleSize = height < 740 ? 24.0 : 28.0;

    final header = Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        children: [
          _topBar(),
          if (_store.syncError != null) ...[
            const SizedBox(height: 8),
            Text(
              _store.syncError!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: chantBrown, fontSize: 12),
            ),
          ],
          SizedBox(height: compact ? 12 : 18),
          GestureDetector(
            onTap: _openMantras,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                mantra?.name ?? 'Naam Jap',
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w600,
                  color: chantBrown,
                  height: 1.15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatElapsed(_store.elapsed),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: chantBrownSoft,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );

    final mala = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _chant,
        child: MalaCounter(count: _store.sessionChants, pulse: _pulse),
      ),
    );

    final stats = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _chant,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Text(
              'Malas Completed: ${formatCount(mantra?.malasCompleted ?? 0)}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: chantBrown,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Total Chants: ${formatCount(mantra?.totalChants ?? 0)}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: chantBrownSoft,
              ),
            ),
          ],
        ),
      ),
    );

    final done = Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
      child: _doneButton(),
    );

    if (compact) {
      return SingleChildScrollView(
        child: Column(
          children: [
            header,
            SizedBox(height: 340, child: mala),
            stats,
            const SizedBox(height: 28),
            done,
          ],
        ),
      );
    }

    return Column(
      children: [
        header,
        Expanded(child: mala),
        stats,
        const SizedBox(height: 28),
        done,
      ],
    );
  }

  Widget _topBar() {
    final user = _store.user;
    return Row(
      children: [
        ChantIconButton(
          icon: Icons.list_alt_rounded,
          tooltip: 'Mantras and targets',
          onPressed: _openMantras,
        ),
        const Spacer(),
        if (_store.syncing)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: chantBrown,
              ),
            ),
          ),
        ChantIconButton(
          icon: Icons.history_rounded,
          tooltip: 'History',
          onPressed: _openJourney,
        ),
        const SizedBox(width: 8),
        if (user == null)
          Material(
            color: Colors.white.withValues(alpha: 0.38),
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              onTap: _signIn,
              borderRadius: BorderRadius.circular(22),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Text(
                  'Sign in',
                  style: TextStyle(
                    color: chantBrown,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          )
        else
          Tooltip(
            message: user.displayName ?? user.email ?? 'Account',
            child: Material(
              color: Colors.white.withValues(alpha: 0.38),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _openAccount,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: chantBrown.withValues(alpha: 0.12),
                  backgroundImage: user.photoURL == null
                      ? null
                      : NetworkImage(user.photoURL!),
                  child: user.photoURL == null
                      ? Text(
                          (user.displayName ?? user.email ?? 'U')
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                            color: chantBrown,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _doneButton() {
    return Material(
      color: Colors.white.withValues(alpha: 0.34),
      borderRadius: BorderRadius.circular(32),
      child: InkWell(
        onTap: _done,
        borderRadius: BorderRadius.circular(32),
        child: Container(
          width: double.infinity,
          height: 58,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
          ),
          child: const Text(
            'Done',
            style: TextStyle(
              color: chantCream,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
