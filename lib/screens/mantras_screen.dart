import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/chant_models.dart';
import '../services/chant_store.dart';
import '../widgets/chant_chrome.dart';

class MantrasScreen extends StatefulWidget {
  const MantrasScreen({super.key, required this.store});

  final ChantStore store;

  @override
  State<MantrasScreen> createState() => _MantrasScreenState();
}

class _MantrasScreenState extends State<MantrasScreen> {
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

  Future<void> _addMantra() async {
    final name = TextEditingController();
    final detail = TextEditingController();
    final target = TextEditingController(text: '$defaultMantraTarget');
    final created = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFF3E0),
          title: const Text('Add mantra', style: TextStyle(color: chantBrown)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Name'),
                textCapitalization: TextCapitalization.words,
              ),
              TextField(
                controller: detail,
                decoration: const InputDecoration(
                  labelText: 'Short line (optional)',
                ),
              ),
              TextField(
                controller: target,
                decoration: const InputDecoration(labelText: 'Target chants'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
    if (created != true || !mounted) {
      name.dispose();
      detail.dispose();
      target.dispose();
      return;
    }
    widget.store.addMantra(
      name: name.text,
      detail: detail.text,
      target: int.tryParse(target.text) ?? defaultMantraTarget,
    );
    name.dispose();
    detail.dispose();
    target.dispose();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _editTarget(Mantra mantra) async {
    final controller = TextEditingController(text: '${mantra.target}');
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFF3E0),
          title: Text(
            mantra.name,
            style: const TextStyle(color: chantBrown, fontSize: 18),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Target chants'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    final next = int.tryParse(controller.text);
    controller.dispose();
    if (saved == true && next != null) {
      widget.store.setTarget(mantra.id, next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
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
                      'My Mantras',
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
            if (store.user == null)
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Text(
                  'Sign in with Google to fetch the mantras and targets saved to your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: chantBrownSoft, height: 1.4),
                ),
              ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: store.mantras.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final mantra = store.mantras[index];
                  final selected = mantra.id == store.activeMantraId;
                  return Material(
                    color: Colors.white.withValues(alpha: selected ? 0.5 : 0.3),
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        store.selectMantra(mantra.id);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mantra.name,
                                    style: const TextStyle(
                                      color: chantBrown,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (mantra.detail.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      mantra.detail,
                                      style: const TextStyle(
                                        color: chantBrownSoft,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      _chip(
                                        '${formatCount(mantra.totalChants)} chants',
                                      ),
                                      _chip(
                                        '${formatCount(mantra.malasCompleted)} malas',
                                      ),
                                      _chip('Target ${formatCount(mantra.target)}'),
                                      IconButton(
                                        tooltip: 'Edit target',
                                        onPressed: () => _editTarget(mantra),
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          color: chantBrown,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (store.mantras.length > 1)
                              IconButton(
                                tooltip: 'Remove mantra',
                                onPressed: () => store.removeMantra(mantra.id),
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: chantBrownSoft,
                                ),
                              )
                            else
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: chantBrown,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _addMantra,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: chantBrown,
                    foregroundColor: chantCream,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Add mantra',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: chantBrown,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
