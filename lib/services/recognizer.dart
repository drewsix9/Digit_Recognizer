import 'package:tflite/tflite.dart';

class Recognizer {
  Future loadMode() {
    Tflite.close();
    return Tflite.loadModel(
      model: "assets/model/baybayin_model.tflite",
      labels: "assets/model/labels.txt",
    );
  }
}
