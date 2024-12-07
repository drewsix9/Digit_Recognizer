import 'package:flutter/material.dart';

import '../models/prediction.dart';

class PredictionWidget extends StatelessWidget {
  final List<Prediction> predictions;
  const PredictionWidget({super.key, required this.predictions});

  Widget _numberWidget(int num, Prediction? prediction) {
    return Column(
      children: <Widget>[
        Text(
          '$num',
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: prediction == null
                ? Colors.black
                : Colors.red.withOpacity(
                    (prediction.confidence * 2).clamp(0, 1).toDouble(),
                  ),
          ),
        ),
        Text(
          prediction == null ? '' : prediction.confidence.toStringAsFixed(3),
          style: const TextStyle(
            fontSize: 12,
          ),
        )
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
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _numberWidget(0, styles[0]),
            _numberWidget(1, styles[1]),
            _numberWidget(2, styles[2]),
            _numberWidget(3, styles[3]),
            _numberWidget(4, styles[4]),
            _numberWidget(5, styles[5]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: 60,
            ),
            _numberWidget(6, styles[6]),
            _numberWidget(7, styles[7]),
            _numberWidget(8, styles[8]),
            _numberWidget(9, styles[9]),
          ],
        )
      ],
    );
  }
}
