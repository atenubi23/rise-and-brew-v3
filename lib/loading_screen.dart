import 'package:flutter/material.dart';
import 'ph_input.dart';
import 'som_classifier.dart';

class LoadingScreen extends StatefulWidget {
  final String imagePath;
  const LoadingScreen({super.key, required this.imagePath});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  // Gumawa ng instance ng Classifier
  final Classifier _classifier = Classifier();

  @override
  void initState() {
    super.initState();
    // Simulan agad ang analysis pagkabukas ng screen
    _analyzeSoil();
  }

  Future<void> _analyzeSoil() async {
    try {
      // 1. I-load ang TFLite model at labels file
      await _classifier.load();

      // 2. Dito tinatawag ang Image Processing sa loob ng som_classifier.dart
      // (Kasama na rito ang Resize to 200x200 at pixel normalization / 255.0)
      final result = await _classifier.classify(widget.imagePath);

      // 3. I-print ang 4-class SOM result sa console (Highly Sufficient, etc.)
      print("AI DEBUG: Result is ${result['label']} (${result['confidence']}%)");

      if (mounted) {
        // 4. Lipat sa PhInputPage.
        // Note: Walang ipinapasang parameters para hindi mag-error ang ph_input.dart mo.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PhInputPage()),
        );
      }
    } catch (e) {
      // Kung may error sa pag-load o pag-analyze, i-print ito sa console
      print("AI ERROR: $e");

      if (mounted) {
        // Opsyonal: Ibalik sa camera kung nag-fail ang analysis
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Analysis failed: $e')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    // Importante: Isara ang interpreter para makatipid sa memory
    _classifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF187B4D), // Kulay ng theme mo
            ),
            const SizedBox(height: 24),
            Text(
              'Analyzing Soil Organic Matter...',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Processing pixels and levels',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}