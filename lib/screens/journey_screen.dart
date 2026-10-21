import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/chant_models.dart';
import '../services/chant_store.dart';
import '../widgets/chant_chrome.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key, required this.store});

  final ChantStore store;

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  @override
  void initState() {
    super.initState();
    widget.store.addListener(_onStore);
  }

  void _onStore() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.store.removeListener(_onStore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    final mantra = store.active;
    final days = _activeDays(store, mantra.id);
    final perDay = days == 0 ? 0.0 : mantra.totalChants / days;
    final remaining = mantra.target - mantra.totalChants;
    final eta = remaining <= 0 || perDay <= 0
        ? null
        : DateTime.now().add(Duration(days: (remaining / perDay).ceil()));

    final allChants = store.mantras.fold<int>(
      0,
      (sum, item) => sum + item.totalChants,
    );

    return ChantScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
              child: Row(
                children: [
                  ChantIconButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'Back',
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Your Journey',
                      style: TextStyle(
                        color: chantBrown,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                children: [
                  if (store.user == null)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Sign in with Google to fetch history saved to your account. This device still keeps what you chant here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: chantBrownSoft, height: 1.4),
                      ),
                    ),
                  Text(
                    mantra.name,
                    style: const TextStyle(
                      color: chantBrown,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ChantCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Overall Progress',
                          style: TextStyle(
                            color: chantBrown,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            _stat(
                              formatCount(mantra.totalChants),
                              'Total\nChants',
                            ),
                            const SizedBox(width: 8),
                            _stat(perDay.toStringAsFixed(1), 'Per Day'),
                            const SizedBox(width: 8),
                            _stat('$days', days == 1 ? 'Day' : 'Days'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x55E08A3C),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            remaining <= 0
                                ? 'Target of ${compactTarget(mantra.target)} reached'
                                : eta == null
                                ? 'ETA to ${compactTarget(mantra.target)}: keep chanting'
                                : 'ETA to ${compactTarget(mantra.target)}: ${DateFormat('dd MMM yyyy').format(eta)}',
                            style: const TextStyle(
                              color: chantBrown,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Daily Breakdown',
                    style: TextStyle(
                      color: chantBrown,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._dayCards(store, mantra.id),
                  const SizedBox(height: 8),
                  Text(
                    'All mantras: ${formatCount(allChants)} chants',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: chantBrownSoft,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.38),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: chantBrown,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: chantBrownSoft, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  int _activeDays(ChantStore store, String mantraId) {
    final days = <String>{};
    for (final entry in store.history) {
      if (entry.mantraId == mantraId && entry.chants > 0) {
        days.add(_dayKey(entry.endedAt));
      }
    }
    if (store.sessionChants > 0 && store.activeMantraId == mantraId) {
      days.add(_dayKey(DateTime.now()));
    }
    return days.length;
  }

  List<Widget> _dayCards(ChantStore store, String mantraId) {
    final totals = <String, int>{};
    for (final entry in store.history) {
      if (entry.mantraId != mantraId || entry.chants <= 0) continue;
      final key = _dayKey(entry.endedAt);
      totals[key] = (totals[key] ?? 0) + entry.chants;
    }
    if (store.sessionChants > 0 && store.activeMantraId == mantraId) {
      final key = _dayKey(DateTime.now());
      totals[key] = (totals[key] ?? 0) + store.sessionChants;
    }
    if (totals.isEmpty) {
      return const [
        Text(
          'Completed sessions show up here after you tap Done.',
          style: TextStyle(color: chantBrownSoft, height: 1.4),
        ),
      ];
    }
    final keys = totals.keys.toList()..sort((a, b) => b.compareTo(a));
    final mantraName = store.active.name;
    return [
      for (final key in keys)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ChantCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        key,
                        style: const TextStyle(
                          color: chantBrown,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      formatCount(totals[key]!),
                      style: const TextStyle(
                        color: chantBrown,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        mantraName,
                        style: const TextStyle(color: chantBrownSoft),
                      ),
                    ),
                    Text(
                      formatCount(totals[key]!),
                      style: const TextStyle(color: chantBrownSoft),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    ];
  }

  String _dayKey(DateTime time) {
    final local = time.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '${local.year}-$month-$day';
  }
}
