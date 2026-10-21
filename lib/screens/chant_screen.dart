import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/chant_models.dart';
import '../services/chant_store.dart';
import '../widgets/chant_banner_ad.dart';
import '../widgets/chant_chrome.dart';
import '../widgets/mala_counter.dart';
import 'journey_screen.dart';

class ChantScreen extends StatefulWidget {
  const ChantScreen({super.key});

  @override
  State<ChantScreen> createState() => _ChantScreenState();
}

class _ChantScreenState extends State<ChantScreen> with WidgetsBindingObserver {
  final ChantStore _store = ChantStore();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _store.addListener(_onStore);
    _store.load();
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
    WidgetsBinding.instance.removeObserver(this);
    _store.removeListener(_onStore);
    _store.flush();
    _store.dispose();
    super.dispose();
  }

  void _chant() {
    _store.chant();
    HapticFeedback.lightImpact();
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message!)));
  }

  Future<void> _openMantras() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFF3E0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: _MantraSheet(store: _store),
        );
      },
    );
  }

  void _openJourney() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => JourneyScreen(store: _store)),
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
                  backgroundImage:
                      user.photoURL == null
                          ? null
                          : NetworkImage(user.photoURL!),
                  child:
                      user.photoURL == null
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
                  leading: const Icon(
                    Icons.insights_outlined,
                    color: chantBrown,
                  ),
                  title: const Text(
                    'Your Journey',
                    style: TextStyle(
                      color: chantBrown,
                      fontWeight: FontWeight.w600,
                    ),
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
                    style: TextStyle(
                      color: chantBrown,
                      fontWeight: FontWeight.w600,
                    ),
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
          _SessionClock(store: _store),
        ],
      ),
    );

    final mala = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _chant,
        child: MalaCounter(count: _store.sessionChants),
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
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
      child: _doneButton(),
    );
    const banner = ChantBannerAd();

    if (compact) {
      return SingleChildScrollView(
        child: Column(
          children: [
            header,
            SizedBox(height: 340, child: mala),
            stats,
            const SizedBox(height: 28),
            done,
            banner,
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
        banner,
      ],
    );
  }

  Widget _topBar() {
    final user = _store.user;
    return Row(
      children: [
        ChantIconButton(
          icon: Icons.list_alt_rounded,
          tooltip: 'Mantra and target',
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
                  backgroundImage:
                      user.photoURL == null
                          ? null
                          : NetworkImage(user.photoURL!),
                  child:
                      user.photoURL == null
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

class _SessionClock extends StatefulWidget {
  const _SessionClock({required this.store});

  final ChantStore store;

  @override
  State<_SessionClock> createState() => _SessionClockState();
}

class _SessionClockState extends State<_SessionClock> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    widget.store.addListener(_onStore);
    _ensureTicker();
  }

  void _onStore() {
    _ensureTicker();
    if (mounted) setState(() {});
  }

  void _ensureTicker() {
    final running = widget.store.sessionChants > 0;
    if (running && _ticker == null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    } else if (!running && _ticker != null) {
      _ticker?.cancel();
      _ticker = null;
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    widget.store.removeListener(_onStore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatElapsed(widget.store.elapsed),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: chantBrownSoft,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _MantraSheet extends StatefulWidget {
  const _MantraSheet({required this.store});

  final ChantStore store;

  @override
  State<_MantraSheet> createState() => _MantraSheetState();
}

class _MantraSheetState extends State<_MantraSheet> {
  late final TextEditingController _target;
  final TextEditingController _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    _target = TextEditingController(text: '${widget.store.target}');
    widget.store.addListener(_onStore);
  }

  void _onStore() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.store.removeListener(_onStore);
    _saveTarget();
    _target.dispose();
    _name.dispose();
    super.dispose();
  }

  void _saveTarget() {
    final next = int.tryParse(_target.text);
    if (next == null || next < 1 || next == widget.store.target) return;
    widget.store.setTarget(next);
  }

  void _addMantra() {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    widget.store.addMantra(name: name);
    _name.clear();
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.72;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: chantBrown.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 14, 20, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mantra and target',
                  style: TextStyle(
                    color: chantBrown,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
              child: Row(
                children: [
                  const Text(
                    'Target',
                    style: TextStyle(
                      color: chantBrown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _target,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(
                        color: chantBrown,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: 'Chants for all mantras',
                      ),
                      onSubmitted: (_) => _saveTarget(),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Save target',
                    onPressed: _saveTarget,
                    icon: const Icon(Icons.check_rounded, color: chantBrown),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                itemCount: store.mantras.length,
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final mantra = store.mantras[index];
                  final selected = mantra.id == store.activeMantraId;
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    selected: selected,
                    selectedTileColor: Colors.white.withValues(alpha: 0.55),
                    title: Text(
                      mantra.name,
                      style: const TextStyle(
                        color: chantBrown,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      '${formatCount(mantra.totalChants)} chants',
                      style: const TextStyle(color: chantBrownSoft),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          selected
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: chantBrown,
                        ),
                        if (store.mantras.length > 1)
                          IconButton(
                            tooltip: 'Remove mantra',
                            onPressed: () => store.removeMantra(mantra.id),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: chantBrownSoft,
                            ),
                          ),
                      ],
                    ),
                    onTap: () => store.selectMantra(mantra.id),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _name,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(color: chantBrown),
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: 'Add a mantra',
                      ),
                      onSubmitted: (_) => _addMantra(),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Add mantra',
                    onPressed: _addMantra,
                    icon: const Icon(Icons.add_rounded, color: chantBrown),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
