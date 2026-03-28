import 'dart:convert';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/services.dart';

/// Resolves free-text country names to ISO 3166-1 alpha-2 for flag widgets.
class CountryNameResolver {
  CountryNameResolver._();
  static final CountryNameResolver instance = CountryNameResolver._();

  final Map<String, String> _exact = {};
  bool _ready = false;
  bool get isReady => _ready;

  static const Map<String, String> _aliases = {
    'usa': 'US',
    'u.s.a.': 'US',
    'u.s.': 'US',
    'united states': 'US',
    'united states of america': 'US',
    'america': 'US',
    'uk': 'GB',
    'u.k.': 'GB',
    'england': 'GB',
    'scotland': 'GB',
    'wales': 'GB',
    'britain': 'GB',
    'great britain': 'GB',
    'northern ireland': 'GB',
    'uae': 'AE',
    'u.a.e.': 'AE',
    'united arab emirates': 'AE',
    'south korea': 'KR',
    'north korea': 'KP',
    'russia': 'RU',
    'russian federation': 'RU',
    'vietnam': 'VN',
    'czech republic': 'CZ',
    'burma': 'MM',
    'holland': 'NL',
    'the netherlands': 'NL',
    'laos': 'LA',
    'ivory coast': 'CI',
    'türkiye': 'TR',
    'turkey': 'TR',
    'taiwan': 'TW',
    'hong kong': 'HK',
    'macau': 'MO',
    'iran': 'IR',
    'syria': 'SY',
    'venezuela': 'VE',
    'bolivia': 'BO',
    'tanzania': 'TZ',
    'moldova': 'MD',
    'micronesia': 'FM',
    'palestine': 'PS',
    'vatican': 'VA',
    'cape verde': 'CV',
    'east timor': 'TL',
    'timor leste': 'TL',
    'swaziland': 'SZ',
    'eswatini': 'SZ',
  };

  String _norm(String s) =>
      s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  void _registerName(String name, String alpha2) {
    final k = _norm(name);
    _exact.putIfAbsent(k, () => alpha2);
    final comma = name.indexOf(',');
    if (comma > 1) {
      final short = _norm(name.substring(0, comma));
      if (short.length >= 3) _exact.putIfAbsent(short, () => alpha2);
    }
    final paren = name.indexOf('(');
    if (paren > 1) {
      final short = _norm(name.substring(0, paren));
      if (short.length >= 3) _exact.putIfAbsent(short, () => alpha2);
    }
  }

  Future<void> loadFromBundle() async {
    if (_ready) return;
    final raw = await rootBundle.loadString('assets/data/iso3166_slim2.json');
    final list = jsonDecode(raw) as List<dynamic>;
    for (final e in list) {
      final m = e as Map<String, dynamic>;
      final name = m['name'] as String;
      final a2 = (m['alpha-2'] as String).toUpperCase();
      _registerName(name, a2);
    }
    for (final e in _aliases.entries) {
      _exact[e.key] = e.value;
    }
    _ready = true;
  }

  /// Returns uppercase alpha-2 or null if unknown.
  String? resolve(String rawInput) {
    if (!_ready || rawInput.trim().isEmpty) return null;
    final key = _norm(rawInput);
    if (_aliases.containsKey(key)) return _aliases[key];
    if (key.length == 2) {
      final up = key.toUpperCase();
      if (FlagCode.fromCountryCode(up) != null) return up;
    }
    if (_exact.containsKey(key)) return _exact[key];
    String? bestCode;
    var bestLen = 0;
    for (final e in _exact.entries) {
      if (e.key.startsWith(key) && e.key.length > bestLen) {
        bestLen = e.key.length;
        bestCode = e.value;
      }
    }
    if (bestCode != null && key.length >= 3) return bestCode;
    for (final e in _exact.entries) {
      if (e.key.length >= 5 && key.contains(e.key)) return e.value;
    }
    return null;
  }
}
