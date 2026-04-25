import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

class Classifier {
  Interpreter? _interpreter;
  List<String> _labels = [];

  // Tugma sa input_shape=(200,200,3) sa Python
  static const int INPUT_SIZE = 200;

  // Binago sa 4 classes base sa iyong labels.txt
  static const int NUM_CLASSES = 4;

  Future<void> load() async {
    try {
      // 1. Siguraduhin na ang TFLite model name ay tama rin (halimbawa: som_model.tflite)
      _interpreter = await Interpreter.fromAsset('assets/som_model.tflite');

      // 2. I-update ang filename dito mula 'labels.txt' patungong 'som_labels.txt'
      final labelsData = await rootBundle.loadString('assets/som_labels.txt');

      _labels = labelsData.split('\n').where((l) => l.isNotEmpty).toList();

      print('SOM Classifier: Model and labels loaded successfully');
    } catch (e) {
      print('Error loading SOM model: $e');
    }
  }

  Future<Map<String, dynamic>> classify(String imagePath) async {
    if (_interpreter == null) return {'label': 'Error', 'confidence': '0', 'index': -1};

    final imageFile = File(imagePath);
    final rawBytes = imageFile.readAsBytesSync();
    final decoded = img.decodeImage(rawBytes);
    if (decoded == null) return {'label': 'Invalid Image', 'confidence': '0', 'index': -1};

    // Resize to 200x200
    final resized = img.copyResize(
      decoded,
      width: INPUT_SIZE,
      height: INPUT_SIZE,
    );

    // Image Preprocessing (rescale = 1./255)
    var input = List.generate(1, (_) =>
        List.generate(INPUT_SIZE, (y) =>
            List.generate(INPUT_SIZE, (x) {
              final pixel = resized.getPixel(x, y);
              // Ginagamit ang modern 'image' package getter (.r, .g, .b)
              return [
                pixel.r / 255.0,
                pixel.g / 255.0,
                pixel.b / 255.0,
              ];
            })
        )
    );

    // Output buffer: [1, 4] dahil 4 labels lang tayo
    var output = List<double>.filled(NUM_CLASSES, 0).reshape([1, NUM_CLASSES]);

    // I-run ang SOM model
    _interpreter!.run(input, output);

    final List<double> scores = List<double>.from(output[0]);

    double maxScore = -1.0;
    int maxIndex = -1;
    for (int i = 0; i < scores.length; i++) {
      if (scores[i] > maxScore) {
        maxScore = scores[i];
        maxIndex = i;
      }
    }

    return {
      'label': _labels.length > maxIndex ? _labels[maxIndex] : 'Class $maxIndex',
      'confidence': (maxScore * 100).toStringAsFixed(1),
      'index': maxIndex,
    };
  }

  void dispose() {
    _interpreter?.close();
  }
}