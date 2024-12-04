import 'dart:convert';

class Prediction {
  final double confidence;
  final int index;
  final String label;

  Prediction({
    required this.confidence,
    required this.index,
    required this.label,
  });

  static void prettyPrintMap(Map<String, dynamic> map) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    String prettyPrint = encoder.convert(map);
    print(prettyPrint);
  }

  factory Prediction.fromJson(var json) {
    return Prediction(
      confidence: json['confidence'],
      index: json['index'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'confidence': confidence});
    result.addAll({'index': index});
    result.addAll({'label': label});

    return result;
  }

  factory Prediction.fromMap(Map<String, dynamic> map) {
    return Prediction(
      confidence: map['confidence']?.toDouble() ?? 0.0,
      index: map['index']?.toInt() ?? 0,
      label: map['label'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
}
