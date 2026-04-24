// loading_screen.dart
import 'package:flutter/material.dart';
import 'ph_input.dart'; // Import your pH input page

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a 2-second analysis, then navigate to pH input screen
    _navigateToPhInput();
  }

  Future<void> _navigateToPhInput() async {
    // Simulate some processing (e.g., image analysis, API call)
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      // Replace the loading screen with PhInputPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PhInputPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.5),
                Colors.grey.shade100.withOpacity(0.5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Analyzing soil sample...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800.withOpacity(0.5),
                  height: 20 / 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}