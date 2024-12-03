import 'package:flutter/material.dart';

import '../models/prediction.dart';

class PredictionWidget extends StatelessWidget {
  final List<Prediction> predictions;
  const PredictionWidget({super.key, required this.predictions});

  Widget _characterWidget(int index, Prediction prediction) {
    return Column(
      children: [
        Text(
          '1',
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: prediction == null
                ? Colors.black
                : Colors.green.withOpacity(
                    (prediction.confidence * 2).clamp(0, 1).toDouble()),
          ),
        ),
        Text(
          prediction == null ? '' : prediction.confidence.toStringAsFixed(2),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  List<dynamic> getPredictionStyles(List<Prediction> predictions) {
    List<dynamic> data = List.filled(63, null);
    for (var pred in predictions) {
      data[pred.index] = pred;
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    var styles = getPredictionStyles(predictions);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < 5; i++) _characterWidget(i, styles[i]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 5; i < 10; i++) _characterWidget(i, styles[i]),
          ],
        )
      ],
    );
  }
}
