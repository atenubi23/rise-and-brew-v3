import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'homescreen_page.dart';
import 'loading_screen.dart';
import 'package:image_picker/image_picker.dart';

class CamOpen extends StatefulWidget {
  const CamOpen({super.key});

  @override
  State<CamOpen> createState() => _CamOpenState();
}

class _CamOpenState extends State<CamOpen> {
  CameraController? _cameraController;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (!mounted) return;
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission denied')),
      );
      return;
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    // Pwedeng palitan ang cameras.first ng cameras[0] (likod) o cameras[1] (harap)
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
      enableAudio: false, // Opsyonal: para hindi humingi ng mic permission
    );

    try {
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraReady = true;
      });
    } catch (e) {
      print("Camera Error: $e");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Capture Soil Sample'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isCameraReady && _cameraController != null
          ? Center(
        child: CameraPreview(_cameraController!),
      )
          : const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Initializing camera...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // ── Gallery Button ──
            FloatingActionButton(
              heroTag: 'gallery',
              backgroundColor: Colors.white24,
              foregroundColor: Colors.white,
              onPressed: () async {
                final picked = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                );
                if (picked == null) return;
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoadingScreen(imagePath: picked.path),
                  ),
                );
              },
              child: const Icon(Icons.photo_library, size: 24),
            ),

            const SizedBox(width: 24),

            // ── Camera Button (original) ──
            FloatingActionButton(
              heroTag: 'camera',
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: () async {
                if (_cameraController == null ||
                    !_cameraController!.value.isInitialized) return;
                try {
                  final photo = await _cameraController!.takePicture();
                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoadingScreen(imagePath: photo.path),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error taking photo: $e')),
                  );
                }
              },
              child: const Icon(Icons.camera_alt, size: 28),
            ),

          ],
        ),
      ),
    );
  }
}