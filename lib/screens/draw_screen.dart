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

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Baybayin Character Recognizer',
        ),
      ),
      body: Column(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Draw a Baybayin character here',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              Center(
                child: Text(
                  'The model will predict the character you drew',
                  style: TextStyle(fontSize: 16),
                ),
              ),
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

  void _initModel() async {
    var res = await _recognizer.loadModel();
    print(res);
  }

  void _recognize() async {
    List<dynamic> pred = await _recognizer.recognize(_points);
    print(pred.map((e) => e.toString()).join(', '));
  }
}
