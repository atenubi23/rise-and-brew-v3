// homescreen_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key});

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  int _selectedIndex = 0;
  CameraController? _cameraController;
  bool _cameraReady = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission denied')),
        );
      }
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
    if (mounted) {
      setState(() {
        _cameraReady = true;
      });
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
      backgroundColor: Colors.white,
      body: SizedBox(
        width: 412,
        height: 917,
        child: Stack(
          children: [
            // Top image section
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 412,
                height: 323,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35.66),
                    bottomRight: Radius.circular(35.66),
                  ),
                ),
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/image_10.png',
                      width: 412,
                      height: 290,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 87,
                      left: 62,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo_1.png',
                            width: 107,
                            height: 30,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rise & Brew',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white,
                              letterSpacing: 0.12,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Hi! Let's keep your goals blooming today.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                              height: 20 / 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom sheet
            Positioned(
              top: 260,
              left: -1,
              child: Container(
                width: 413,
                height: 656,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 17),
                    SvgPicture.asset(
                      'assets/line_6.svg',
                      width: 141,
                      height: 3,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: IndexedStack(
                        index: _selectedIndex,
                        children: [
                          const HomeView(),
                          CameraViewWidget(
                            cameraReady: _cameraReady,
                            cameraController: _cameraController,
                          ),
                          const ListViewPlaceholder(),
                        ],
                      ),
                    ),
                    // Bottom navigation
                    Container(
                      width: 396,
                      height: 83,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildNavItem(Icons.home, 'Home', 0),
                          _buildNavItem(Icons.camera_alt, 'Cam', 1),
                          _buildNavItem(Icons.menu_book, 'List', 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        width: 83.37,
        height: 85.5,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isActive)
              Container(
                width: 83,
                height: 4,
                color: const Color(0xFF187B4D),
              )
            else
              const SizedBox(height: 4),
            const Spacer(),
            Icon(
              icon,
              size: 26,
              color: isActive
                  ? const Color(0xFF187B4D)
                  : Colors.black.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                fontSize: 12.8,
                color: isActive
                    ? Colors.black
                    : Colors.black.withValues(alpha: 0.5),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// ----- Home View -----
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemCount: fieldCards.length,
      itemBuilder: (context, index) {
        final card = fieldCards[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: Color(0xFFE8E9E9)),
            ),
            elevation: 0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: const Color(0xFF187B4D).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.89),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        card.name,
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${card.som}\n${card.ph}\n${card.date}',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF908BA6),
                      height: 20 / 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'View details',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_downward, size: 18, color: Colors.black),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ----- Camera View Widget (live preview) -----
class CameraViewWidget extends StatelessWidget {
  final bool cameraReady;
  final CameraController? cameraController;

  const CameraViewWidget({
    super.key,
    required this.cameraReady,
    required this.cameraController,
  });

  @override
  Widget build(BuildContext context) {
    if (!cameraReady || cameraController == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Initializing camera...'),
          ],
        ),
      );
    }
    return CameraPreview(cameraController!);
  }
}

// ----- List View Placeholder -----
class ListViewPlaceholder extends StatelessWidget {
  const ListViewPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'List Screen\n(Coming soon)',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF908BA6),
        ),
      ),
    );
  }
}

// ----- Data Models -----
class FieldCard {
  final int id;
  final String name;
  final String som;
  final String ph;
  final String date;
  final bool isLast;

  FieldCard({
    required this.id,
    required this.name,
    required this.som,
    required this.ph,
    required this.date,
    required this.isLast,
  });
}

final List<FieldCard> fieldCards = [
  FieldCard(
    id: 1,
    name: 'North Field',
    som: '4.2 % SOM',
    ph: 'Neutral PH level',
    date: 'Oct. 25 2025',
    isLast: false,
  ),
  FieldCard(
    id: 2,
    name: 'North Field',
    som: '4.2 % SOM',
    ph: 'Neutral PH level',
    date: 'Oct. 25 2025',
    isLast: false,
  ),
  FieldCard(
    id: 3,
    name: 'North Field',
    som: '4.2 % SOM',
    ph: 'Neutral PH level',
    date: 'Oct. 25 2025',
    isLast: true,
  ),
];