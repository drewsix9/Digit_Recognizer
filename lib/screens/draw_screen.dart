import 'dart:typed_data';

import 'package:baybayin_character_recognition/screens/prediction_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/prediction.dart';
import '../provider/prediction_provider.dart';
import '../services/recognizer.dart';
import '../utils/constants.dart';
import 'drawing_painter.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final List<Offset?> _points = [];
  final _recognizer = Recognizer();
  List<Prediction> _prediction = [];
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  @override
  dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        title: const Text(
          'Baybayin Character Recognizer',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Draw a Baybayin character here',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'The model will predict the character you drew',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              _imagePreviewWidget(),
            ],
          ),
          _drawCanvasWidget(),
          const SizedBox(
            height: 20,
          ),
          PredictionWidget(predictions: _prediction),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'saveButton',
            onPressed: () {
              _recognize();
            },
            child: const Icon(Icons.save, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'replayButton',
            onPressed: () {
              Provider.of<PredictionProvider>(context, listen: false)
                  .setLoading(true);
              setState(() {
                _points.clear();
                _prediction.clear();
              });
            },
            child: const Icon(Icons.replay, color: Colors.white),
          ),
          const SizedBox(height: 40),
        ],
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
        },
        child: CustomPaint(
          painter: DrawingPainter(_points),
        ),
      ),
    );
  }

  Widget _imagePreviewWidget() {
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
      print('\nPrediction: ');
      for (var element in _prediction) {
        Prediction.prettyPrintMap(element.toMap());
      }
    });
  }
}
