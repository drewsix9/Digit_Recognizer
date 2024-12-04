import 'package:baybayin_character_recognition/utils/baybayin.dart';
import 'package:flutter/material.dart';

import '../models/prediction.dart';

class PredictionWidget extends StatelessWidget {
  final List<Prediction> predictions;
  const PredictionWidget({super.key, required this.predictions});

  Widget _characterWidget(int index, Prediction? prediction, double fontSize) {
    return Column(
      children: [
        Text(
          Baybayin.labels[index],
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          Baybayin.characters[index],
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: prediction == null
                ? Colors.black
                : Colors.red.withOpacity(
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
    if (predictions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (predictions.length == 1) {
      return _characterWidget(predictions[0].index, predictions[0], 60);
    } else {
      return Column(
        children: [
          _characterWidget(predictions[0].index, predictions[0], 60),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              scrollDirection: Axis.horizontal,
              itemCount: Baybayin.characters.length,
              itemBuilder: (context, index) {
                if (index == predictions[0].index) {
                  return const SizedBox.shrink();
                }
                return _characterWidget(index, styles[index], 30);
              },
            ),
          ),
        ],
      );
    }
  }
}
