// cam_open.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'homescreen_page.dart';
import 'loading_screen.dart';
import 'som_classifier.dart'

class CamOpen extends StatefulWidget {
  const CamOpen({super.key});

  @override
  State<CamOpen> createState() => _CamOpenState();
}

class _CamOpenState extends State<CamOpen> {
  CameraController? _cameraController;
  bool _isCameraReady = false;
  final Classifier _classifier = Classifier();

  @override
  void initState() {
    super.initState();
    _initCamera();
    _classifier.load();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    // Check mounted before using context
    if (!mounted) return;
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission denied')),
      );
      return;
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {
      _isCameraReady = true;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _classifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Camera'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreenPage()),
              );
            },
          ),
        ],
      ),
      body: _isCameraReady && _cameraController != null
          ? CameraPreview(_cameraController!)
          : const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Initializing camera...'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_cameraController == null || !_cameraController!.value.isInitialized) return;

          try {
            final photo = await _cameraController!.takePicture();

            // ← DITO ang inference, simple na lang
            final result = await _classifier.classify(photo.path);

            if (!mounted) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoadingScreen(result: result),
              ),
            );

          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}