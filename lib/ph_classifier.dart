import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

class Classifier {
  Interpreter? _interpreter;
  List<String> _labels = [];

  // I-adjust ito depende sa model mo
  static const int INPUT_SIZE = 224;
  static const int NUM_CLASSES = 10; // ilang classes ang model mo?

  Future<void> load() async {
    // Load model
    _interpreter = await Interpreter.fromAsset('assets/your_model.tflite');

    // Load labels
    final labelsData = await rootBundle.loadString('assets/labels.txt');
    _labels = labelsData.split('\n').where((l) => l.isNotEmpty).toList();
  }

  Future<Map<String, dynamic>> classify(String imagePath) async {
    // 1. I-load ang image
    final imageFile = File(imagePath);
    final rawBytes = imageFile.readAsBytesSync();
    final decoded = img.decodeImage(rawBytes)!;

    // 2. I-resize para sa model
    final resized = img.copyResize(
      decoded,
      width: INPUT_SIZE,
      height: INPUT_SIZE,
    );

    // 3. I-convert sa tensor [1, 224, 224, 3]
    final input = List.generate(1, (_) =>
        List.generate(INPUT_SIZE, (y) =>
            List.generate(INPUT_SIZE, (x) {
              final pixel = resized.getPixel(x, y);
              return [
                img.getRed(pixel) / 255.0,
                img.getGreen(pixel) / 255.0,
                img.getBlue(pixel) / 255.0,
              ];
            })
        )
    );

    // 4. Output buffer
    final output = List.filled(NUM_CLASSES, 0.0).reshape([1, NUM_CLASSES]);

    // 5. I-run ang inference
    _interpreter!.run(input, output);

    // 6. Hanapin ang pinaka-mataas na confidence
    final scores = List<double>.from(output[0]);
    final maxScore = scores.reduce((a, b) => a > b ? a : b);
    final maxIndex = scores.indexOf(maxScore);

    return {
      'label': _labels.isNotEmpty ? _labels[maxIndex] : 'Class $maxIndex',
      'confidence': (maxScore * 100).toStringAsFixed(1), // e.g. "93.4"
      'index': maxIndex,
    };
  }

  void dispose() {
    _interpreter?.close();
  }
}