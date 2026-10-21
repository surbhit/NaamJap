import 'package:intl/intl.dart';

const int beadsPerMala = 108;
const int defaultMantraTarget = 11000;

int asInt(dynamic value, [int fallback = 0]) {
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

Map<String, dynamic> asStringMap(dynamic value) {
  if (value is Map) {
    return value.map((key, entry) => MapEntry(key.toString(), entry));
  }
  return {};
}

class Mantra {
  Mantra({
    required this.id,
    required this.name,
    this.detail = '',
    this.totalChants = 0,
    this.target = defaultMantraTarget,
    this.createdAt = 0,
  });

  final String id;
  String name;
  String detail;
  int totalChants;
  int target;
  int createdAt;

  int get malasCompleted => totalChants ~/ beadsPerMala;

  Mantra copy() {
    return Mantra(
      id: id,
      name: name,
      detail: detail,
      totalChants: totalChants,
      target: target,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'detail': detail,
      'totalChants': totalChants,
      'target': target,
      'createdAt': createdAt,
    };
  }

  factory Mantra.fromJson(String id, Map<String, dynamic> json) {
    return Mantra(
      id: id,
      name: (json['name'] ?? 'Mantra').toString(),
      detail: (json['detail'] ?? '').toString(),
      totalChants: asInt(json['totalChants']),
      target: asInt(json['target'], defaultMantraTarget),
      createdAt: asInt(json['createdAt']),
    );
  }
}

class ChantHistoryEntry {
  ChantHistoryEntry({
    required this.id,
    required this.mantraId,
    required this.mantraName,
    required this.chants,
    required this.startedAt,
    required this.endedAt,
  });

  final String id;
  final String mantraId;
  final String mantraName;
  final int chants;
  final DateTime startedAt;
  final DateTime endedAt;

  int get durationSeconds => endedAt.difference(startedAt).inSeconds;

  Map<String, dynamic> toJson() {
    return {
      'mantraId': mantraId,
      'mantraName': mantraName,
      'chants': chants,
      'startedAt': startedAt.millisecondsSinceEpoch,
      'endedAt': endedAt.millisecondsSinceEpoch,
    };
  }

  factory ChantHistoryEntry.fromJson(String id, Map<String, dynamic> json) {
    final ended = DateTime.fromMillisecondsSinceEpoch(asInt(json['endedAt']));
    final startedMs = asInt(json['startedAt']);
    return ChantHistoryEntry(
      id: id,
      mantraId: (json['mantraId'] ?? '').toString(),
      mantraName: (json['mantraName'] ?? '').toString(),
      chants: asInt(json['chants']),
      startedAt: startedMs == 0
          ? ended
          : DateTime.fromMillisecondsSinceEpoch(startedMs),
      endedAt: ended,
    );
  }
}

List<Mantra> defaultMantras() {
  return [
    Mantra(
      id: 'gan-ganapataye',
      name: 'Gan Ganapataye Namah',
      detail: 'Om Gam Ganapataye Namah',
      createdAt: 1,
    ),
    Mantra(
      id: 'ram-naam',
      name: 'Ram Naam',
      detail: 'Ram',
      createdAt: 2,
    ),
    Mantra(
      id: 'om-namah-shivaya',
      name: 'Om Namah Shivaya',
      detail: 'Om Namah Shivaya',
      createdAt: 3,
    ),
    Mantra(
      id: 'durga-mantra',
      name: 'Durga Mantra',
      detail: 'Om Durgayai Namah',
      createdAt: 4,
    ),
    Mantra(
      id: 'shri-ganeshava',
      name: 'Shri Ganeshava Namah',
      detail: 'Om Shri Ganeshaya Namah',
      createdAt: 5,
    ),
  ];
}

String formatCount(int value) {
  return NumberFormat.decimalPattern('en').format(value);
}

String formatElapsed(Duration duration) {
  final safe = duration.isNegative ? Duration.zero : duration;
  final hours = safe.inHours;
  final minutes = safe.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = safe.inSeconds.remainder(60).toString().padLeft(2, '0');
  if (hours > 0) return '$hours:$minutes:$seconds';
  return '$minutes:$seconds';
}

String compactTarget(int target) {
  if (target >= 10000000 && target % 10000000 == 0) {
    final crore = target ~/ 10000000;
    return '$crore crore';
  }
  if (target >= 1000 && target % 1000 == 0) {
    return '${target ~/ 1000}k';
  }
  return formatCount(target);
}
