class Prediction {
  final double confidence;
  final int index;
  final String label;

  Prediction(
    this.confidence,
    this.index,
    this.label,
  );

  factory Prediction.fromJson(Map<String?, dynamic> json) {
    return Prediction(
      json['confidence'] as double,
      json['index'] as int,
      json['label'] as String,
    );
  }
}
