import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Row data for the exported chanting stats card.
typedef ChantingCountryRow = ({String country, int count, String? iso2});

/// Share card for export; height grows with row count so ~20 countries stay readable.
class ChantingStatsShareCard extends StatelessWidget {
  const ChantingStatsShareCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.reportDate,
    required this.rows,
    required this.totalChants,
  });

  final String title;
  final String subtitle;
  final DateTime reportDate;
  final List<ChantingCountryRow> rows;
  final int totalChants;

  static const double width = 440;

  /// Empty-state and minimum export height.
  static const double minHeight = 560;

  static const int _compactAfterRowCount = 16;

  /// Space before the country list (ornament, headline, subtitle, date).
  static const double _headerBlockNormal = 226;
  static const double _headerBlockCompact = 198;

  /// Space after the country list (dividers, total, branding).
  static const double _footerBlockNormal = 102;
  static const double _footerBlockCompact = 96;

  /// Per-row band: divider + padding + up to two lines of country + count.
  static const double _perRowNormal = 34;
  static const double _perRowCompact = 30;

  static const EdgeInsets _paddingNormal = EdgeInsets.fromLTRB(32, 40, 32, 28);
  static const EdgeInsets _paddingCompact = EdgeInsets.fromLTRB(32, 32, 32, 22);

  static double heightForRowCount(int rowCount) {
    if (rowCount <= 0) return minHeight;
    final compact = rowCount > _compactAfterRowCount;
    final padV =
        compact
            ? _paddingCompact.top + _paddingCompact.bottom
            : _paddingNormal.top + _paddingNormal.bottom;
    final header =
        compact ? _headerBlockCompact : _headerBlockNormal;
    final footer =
        compact ? _footerBlockCompact : _footerBlockNormal;
    final perRow = compact ? _perRowCompact : _perRowNormal;
    return (padV + header + rowCount * perRow + footer).clamp(minHeight, 2000);
  }

  static String _formatInt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF1C1917);
    const inkMuted = Color(0xFF57534E);
    const line = Color(0xFFE7E2D9);
    const accent = Color(0xFFC2410C);
    const paperTop = Color(0xFFFBF9F6);
    const paperBottom = Color(0xFFF0EBE3);

    final n = rows.length;
    final compact = n > _compactAfterRowCount;
    final padding = compact ? _paddingCompact : _paddingNormal;
    final cardHeight = heightForRowCount(n);
    final perRow = compact ? _perRowCompact : _perRowNormal;
    final listHeight = n == 0 ? 100.0 : n * perRow;

    final titleSize = n > 18 ? 24.0 : 28.0;
    final countrySize = compact ? 12.5 : 13.5;
    final countSize = compact ? 13.5 : 14.5;
    final rowPaddingV = compact ? 5.0 : 7.0;
    final omSize = compact ? 12.0 : 14.0;
    final subtitleSize = compact ? 10.0 : 11.0;
    final gapAfterOm = compact ? 20.0 : 28.0;
    final gapTitleSub = compact ? 8.0 : 10.0;
    final gapAfterSubtitle = compact ? 6.0 : 8.0;
    final gapBeforeList = compact ? 18.0 : 22.0;

    final dateStr = DateFormat('d MMMM y').format(reportDate);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: width,
        height: cardHeight,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [paperTop, paperBottom],
          ),
          border: Border.all(color: line, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: accent.withValues(alpha: 0.35),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'ॐ',
                      style: GoogleFonts.notoSans(
                        fontSize: omSize,
                        color: accent.withValues(alpha: 0.7),
                        height: 1,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: accent.withValues(alpha: 0.35),
                    ),
                  ),
                ],
              ),
              SizedBox(height: gapAfterOm),
              Text(
                title.trim().isEmpty ? 'Chanting across borders' : title.trim(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w600,
                  color: ink,
                  height: 1.12,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: gapTitleSub),
              Text(
                subtitle.trim().isEmpty
                    ? 'Community snapshot'
                    : subtitle.trim(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: subtitleSize,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.4,
                  color: inkMuted,
                ),
              ),
              SizedBox(height: gapAfterSubtitle),
              Text(
                'As of $dateStr',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: compact ? 9.5 : 10.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: accent.withValues(alpha: 0.9),
                ),
              ),
              SizedBox(height: gapBeforeList),
              if (rows.isEmpty)
                SizedBox(
                  height: listHeight,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'No rows parsed yet.\n'
                        'Each line: country name, then count\n'
                        '(e.g. India 1000000).',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          height: 1.45,
                          color: inkMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  height: listHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < rows.length; i++) ...[
                        if (i > 0)
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: line,
                          ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: rowPaddingV),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: _ShareRowFlag(
                                  iso2: rows[i].iso2,
                                  inkMuted: inkMuted,
                                  compact: compact,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  rows[i].country,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: countrySize,
                                    fontWeight: FontWeight.w500,
                                    color: ink,
                                    height: 1.25,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatInt(rows[i].count),
                                style: GoogleFonts.inter(
                                  fontSize: countSize,
                                  fontWeight: FontWeight.w600,
                                  color: ink,
                                  height: 1.25,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              const Spacer(),
              const SizedBox(height: 8),
              Divider(
                height: 1,
                thickness: 1,
                color: accent.withValues(alpha: 0.25),
              ),
              SizedBox(height: compact ? 10 : 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'TOTAL CHANTS',
                    style: GoogleFonts.inter(
                      fontSize: compact ? 9 : 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.4,
                      color: inkMuted,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatInt(totalChants),
                    style: GoogleFonts.inter(
                      fontSize: compact ? 17 : 20,
                      fontWeight: FontWeight.w700,
                      color: accent,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
              SizedBox(height: compact ? 16 : 22),
              Text(
                'Naam Jap',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: compact ? 8.5 : 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.2,
                  color: inkMuted.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareRowFlag extends StatelessWidget {
  const _ShareRowFlag({
    required this.iso2,
    required this.inkMuted,
    required this.compact,
  });

  final String? iso2;
  final Color inkMuted;
  final bool compact;

  static const double _w = 26;
  static const double _h = 17;

  @override
  Widget build(BuildContext context) {
    final code = iso2?.toUpperCase();
    if (code == null ||
        code.length != 2 ||
        FlagCode.fromCountryCode(code) == null) {
      return SizedBox(
        width: _w,
        height: _h,
        child: Icon(
          Icons.public_rounded,
          size: compact ? 13 : 14,
          color: inkMuted.withValues(alpha: 0.65),
        ),
      );
    }
    return CountryFlag.fromCountryCode(
      code,
      theme: ImageTheme(
        width: _w,
        height: _h,
        shape: RoundedRectangle(3),
      ),
    );
  }
}
