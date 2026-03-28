import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../utils/country_name_resolver.dart';
import '../utils/image_download.dart';
import '../widgets/chanting_stats_share_card.dart';

/// One line: country name, then whitespace/comma/colon/tab/pipe, then a number (commas allowed).
final RegExp _chantingLinePattern = RegExp(
  r'^(.*)[\s,:\t|]+([\d][\d,\s]*)$',
);

class ChantingStatsScreen extends StatefulWidget {
  const ChantingStatsScreen({super.key});

  @override
  State<ChantingStatsScreen> createState() => _ChantingStatsScreenState();
}

class _ChantingStatsScreenState extends State<ChantingStatsScreen> {
  final GlobalKey _posterKey = GlobalKey();
  final TextEditingController _title = TextEditingController(
    text: 'Chanting across borders',
  );
  final TextEditingController _subtitle = TextEditingController(
    text: 'Community snapshot',
  );
  final TextEditingController _bulkData = TextEditingController(
    text: 'India 1000000\n'
        'United States 500000\n'
        'United Kingdom 250000',
  );

  late DateTime _reportDate;

  bool _exporting = false;

  void _onFieldChanged() => setState(() {});

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _reportDate = DateTime(now.year, now.month, now.day);
    _title.addListener(_onFieldChanged);
    _subtitle.addListener(_onFieldChanged);
    _bulkData.addListener(_onFieldChanged);
    CountryNameResolver.instance.loadFromBundle().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _title.removeListener(_onFieldChanged);
    _subtitle.removeListener(_onFieldChanged);
    _bulkData.removeListener(_onFieldChanged);
    _title.dispose();
    _subtitle.dispose();
    _bulkData.dispose();
    super.dispose();
  }

  List<ChantingCountryRow> _parsedRows() {
    final resolver = CountryNameResolver.instance;
    final out = <ChantingCountryRow>[];
    for (final raw in _bulkData.text.split(RegExp(r'\r?\n'))) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      final m = _chantingLinePattern.firstMatch(line);
      if (m == null) continue;
      final name = m.group(1)!.trim();
      if (name.isEmpty) continue;
      final digits = m.group(2)!.replaceAll(RegExp(r'[^\d]'), '');
      final n = int.tryParse(digits);
      if (n == null) continue;
      if (n < 0) continue;
      final iso = resolver.isReady ? resolver.resolve(name) : null;
      out.add((country: name, count: n, iso2: iso));
    }
    return out;
  }

  int _nonEmptyLineCount() {
    var n = 0;
    for (final raw in _bulkData.text.split(RegExp(r'\r?\n'))) {
      if (raw.trim().isNotEmpty) n++;
    }
    return n;
  }

  int _total(List<ChantingCountryRow> rows) =>
      rows.fold<int>(0, (s, e) => s + e.count);

  Future<void> _pickReportDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _reportDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _reportDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  Future<void> _exportPng() async {
    if (!kIsWeb) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PNG export is available in the web version.'),
        ),
      );
      return;
    }

    final parsed = _parsedRows();
    if (parsed.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter at least one line: country name, then count (e.g. India 1500000).',
          ),
        ),
      );
      return;
    }

    setState(() => _exporting = true);
    await Future<void>.delayed(const Duration(milliseconds: 150));
    await SchedulerBinding.instance.endOfFrame;

    try {
      final boundary =
          _posterKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        throw StateError('Preview is not ready yet.');
      }
      final image = await boundary.toImage(pixelRatio: 3);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) {
        throw StateError('Could not encode image.');
      }
      downloadPng(data.buffer.asUint8List(), 'naam_jap_chanting_stats.png');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Image download started.')));
    } on UnsupportedError catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Export is only supported on web.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Widget _buildForm(bool wide) {
    final parsed = _parsedRows();
    final linesWithText = _nonEmptyLineCount();
    final skipped = linesWithText - parsed.length;

    return Container(
      constraints: BoxConstraints(maxWidth: wide ? 420 : double.infinity),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Your data',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _title,
            decoration: const InputDecoration(
              labelText: 'Headline',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _subtitle,
            decoration: const InputDecoration(
              labelText: 'Subtitle',
              hintText: 'Shown on the image above the date',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _pickReportDate,
            borderRadius: BorderRadius.circular(8),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Date on image',
                border: OutlineInputBorder(),
                isDense: true,
                suffixIcon: Icon(Icons.calendar_today, size: 18),
              ),
              child: Text(
                DateFormat.yMMMMd().format(_reportDate),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.primaryText,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Countries & counts',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'One country per line: name, then spaces or comma/colon/tab, then the chant count. '
            'Example: India 1500000 or Canada: 900,000',
            style: GoogleFonts.inter(
              fontSize: 11,
              height: 1.35,
              color: AppColors.lightText,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _bulkData,
            decoration: const InputDecoration(
              labelText: 'Paste or type your list',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            style: GoogleFonts.inter(fontSize: 14, height: 1.4),
            maxLines: 16,
            minLines: 8,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 8),
          Text(
            '${parsed.length} ${parsed.length == 1 ? 'country' : 'countries'} in preview'
            '${skipped > 0 ? ' · $skipped non-empty ${skipped == 1 ? 'line' : 'lines'} skipped (need name + number)' : ''}',
            style: GoogleFonts.inter(
              fontSize: 11,
              color:
                  skipped > 0
                      ? AppColors.darkOrange
                      : AppColors.lightText,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _exporting ? null : _exportPng,
            icon:
                _exporting
                    ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.whiteText,
                      ),
                    )
                    : const Icon(Icons.download_rounded, size: 20),
            label: Text(_exporting ? 'Exporting…' : 'Export as PNG'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              foregroundColor: AppColors.whiteText,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          if (!kIsWeb)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Open this page in a browser to download the image.',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.lightText,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final parsed = _parsedRows();
    final total = _total(parsed);

    return Column(
      children: [
        Text(
          'Preview',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: AppColors.whiteText.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 12),
        RepaintBoundary(
          key: _posterKey,
          child: ChantingStatsShareCard(
            title: _title.text,
            subtitle: _subtitle.text,
            reportDate: _reportDate,
            rows: parsed,
            totalChants: total,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 1000;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chanting stats'),
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: AppColors.whiteText,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
          tooltip: 'Back to Home',
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: wide ? 40 : 16,
              vertical: 24,
            ),
            child: Center(
              child:
                  wide
                      ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildForm(true),
                          const SizedBox(width: 40),
                          Flexible(child: _buildPreview()),
                        ],
                      )
                      : Column(
                        children: [
                          _buildForm(false),
                          const SizedBox(height: 32),
                          _buildPreview(),
                        ],
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
