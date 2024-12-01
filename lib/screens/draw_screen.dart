import 'dart:typed_data';

import 'package:flutter/material.dart';

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
  final _prediction = [];
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        title: const Text(
          'Baybayin Character Recognizer',
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
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
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'The model will predict the character you drew',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              _imagePreviewWidget(),
            ],
          ),
          const SizedBox(height: 20),
          Container(
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
                  print(localPosition);
                  setState(() {
                    _points.add(localPosition);
                  });
                }
              },
              onPanEnd: (DragEndDetails details) {
                _points.add(null);
                _recognize();
              },
              child: CustomPaint(
                painter: DrawingPainter(_points),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _points.clear();
          });
        },
        child: const Icon(Icons.clear, color: Colors.white),
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
              return Image.memory(snapshot.data!);
            } else {
              return const Text('No Image');
            }
          }),
    );
  }

  void _initModel() async {
    var res = await _recognizer.loadModel();
    print(res);
  }

  Future<Uint8List> _previewImage() async {
    return await _recognizer.previewImage(_points);
  }

  void _recognize() async {
    List<dynamic> pred = await _recognizer.recognize(_points);
    print(pred);
    _prediction;
    setState(() {
      // _prediction = pred.map((json) => Prediction.fromJson(json)).toList();
    });
  }
}
