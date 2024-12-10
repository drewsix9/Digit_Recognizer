import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/prediction.dart';
import '../services/recognizer.dart';
import '../utils/constants.dart';
import 'drawing_painter.dart';
import 'prediction_widget.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final List<Offset?> _points = []; // List of points to draw the digit
  final _recognizer =
      Recognizer(); // Initialize the Recognizer class from services/recognizer.dart
  List<Prediction> _prediction = []; // List of predictions

  @override
  void initState() {
    super.initState();
    _initModel(); // Initialize the model
  }

  @override
  dispose() {
    _recognizer.dispose(); // Dispose the model (free up resources)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digit Recognizer',
            style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'MNIST database of handwritten digits',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'The digits have been size-normalized and centered in a fixed-size images (28 x 28)',
                      )
                    ],
                  ),
                ),
              ),
              _mnistPreviewImage(), // Call the widget to display the preview image
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          _drawCanvasWidget(), // Call the widget to draw the canvas
          const SizedBox(
            height: 10,
          ),
          PredictionWidget(
            predictions: _prediction,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.clear),
        onPressed: () {
          setState(() {
            _points.clear(); // Clear the points
            _prediction.clear(); // Clear the predictions
          });
        },
      ),
    );
  }

  Widget _drawCanvasWidget() {
    return Container(
      width: Constants.canvasSize + Constants.borderSize * 2,
      height: Constants.canvasSize + Constants.borderSize * 2,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: Constants.borderSize,
        ),
      ),
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          Offset localPosition = details.localPosition;
          if (localPosition.dx >= 0 &&
              localPosition.dy >= 0 &&
              localPosition.dx <= Constants.canvasSize &&
              localPosition.dy <= Constants.canvasSize) {
            setState(() {
              _points.add(localPosition);
            });
          }
        },
        onPanEnd: (DragEndDetails details) {
          _points.add(null);
          _recognize(); // THIS IS THE MAIN FUNCTION TO RECOGNIZE THE DIGIT
        },
        child: CustomPaint(
          painter: DrawingPainter(_points),
        ),
      ),
    );
  }

  Widget _mnistPreviewImage() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.black,
      child: FutureBuilder(
          future: _previewImage(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.memory(
                snapshot.data!,
                fit: BoxFit.contain,
              );
            } else {
              return const Center(
                child: Text('Error'),
              );
            }
          }),
    );
  }

  void _initModel() async {
    await _recognizer.loadModel();
  }

  Future<Uint8List> _previewImage() async {
    return await _recognizer.previewImage(_points);
  }

  void _recognize() async {
    List<dynamic> pred = await _recognizer.recognize(_points);
    setState(() {
      _prediction = pred.map((json) => Prediction.fromJson(json)).toList();
      print('\nPrediction: '); // Print the prediction to the terminal
      for (var element in _prediction) {
        Prediction.prettyPrintMap(element.toMap());
      }
    });
  }
}
