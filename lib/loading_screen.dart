// loading_screen.dart
import 'package:flutter/material.dart';
import 'som_classifier.dart';
import 'ph_input.dart';

class LoadingScreen extends StatefulWidget {
  final String imagePath;

  const LoadingScreen({super.key, required this.imagePath});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final Classifier _classifier = Classifier();

  @override
  void initState() {
    super.initState();
    _runClassification();
  }

  Future<void> _runClassification() async {
    try {
      await _classifier.load();
      final result = await _classifier.classify(widget.imagePath);

      if (!mounted) return;

      // ── After SOM classification → go to pH input ──
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PhInputPage(
            imagePath: widget.imagePath,
            prediction: result['label'] ?? 'Unknown',
            confidence: result['confidence'] ?? '0.0',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Classification error: $e')),
      );
      Navigator.pop(context);
    } finally {
      _classifier.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 24),
            const Text(
              'Analyzing soil sample...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}