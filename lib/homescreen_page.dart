import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'cam_open.dart';
import 'list_view.dart';
import 'database_helper.dart';

class HomeScreenPage extends StatefulWidget {
  final int initialIndex;
  const HomeScreenPage({super.key, this.initialIndex = 0});

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  late int _selectedIndex;
  CameraController? _cameraController;
  bool _cameraReady = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final topSectionHeight = screenHeight * 0.35;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            // ── Top image section ──
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: screenWidth,
                height: topSectionHeight,
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
                      width: screenWidth,
                      height: topSectionHeight * 0.9,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: topSectionHeight * 0.25,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/logo_1.png',
                              width: screenWidth * 0.25,
                              height: screenHeight * 0.04,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'Rise & Brew',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.032,
                                color: Colors.white,
                                letterSpacing: 0.12,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.1),
                              child: Text(
                                "Hi! Let's keep your goals blooming today.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.white,
                                  height: 1.43,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom sheet ──
            Positioned(
              top: topSectionHeight - 20,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.015),
                    SvgPicture.asset(
                      'assets/line_6.svg',
                      width: screenWidth * 0.34,
                      height: screenHeight * 0.003,
                    ),
                    SizedBox(height: screenHeight * 0.01),

                    // ── Page content ──
                    Expanded(
                      child: IndexedStack(
                        index: _selectedIndex,
                        children: [
                          const HomeView(),
                          CameraViewWidget(
                            cameraReady: _cameraReady,
                            cameraController: _cameraController,
                          ),
                          const ListViewWidget(),
                        ],
                      ),
                    ),

                    // ── Bottom Nav ──
                    Container(
                      width: screenWidth,
                      height: screenHeight * 0.105,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildNavItem(Icons.home, 'Home', 0, screenWidth, screenHeight),
                          _buildNavItem(Icons.camera_alt, 'Cam', 1, screenWidth, screenHeight),
                          _buildNavItem(Icons.menu_book, 'List', 2, screenWidth, screenHeight),
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

  Widget _buildNavItem(IconData icon, String label, int index,
      double screenWidth, double screenHeight) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CamOpen()),
          );
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      child: Container(
        width: screenWidth * 0.32,
        height: screenHeight * 0.11,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isActive)
              Container(
                width: screenWidth * 0.2,
                height: screenHeight * 0.004,
                color: const Color(0xFF187B4D),
              )
            else
              SizedBox(height: screenHeight * 0.004),
            const Spacer(),
            Icon(
              icon,
              size: screenWidth * 0.065,
              color: isActive
                  ? const Color(0xFF187B4D)
                  : Colors.black.withValues(alpha: 0.5),
            ),
            SizedBox(height: screenHeight * 0.005),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
                fontSize: screenWidth * 0.032,
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

// ─────────────────────────────────────────
// HOME VIEW — latest 3 records from DB
// ─────────────────────────────────────────
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<SoilResult> _recentResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final all = await DatabaseHelper.instance.getAllResults();
    setState(() {
      _recentResults = all.reversed.take(3).toList();
      _isLoading = false;
    });
  }

  Color _getPredictionColor(String prediction) {
    switch (prediction.toLowerCase()) {
      case 'highly sufficient':   return const Color(0xFF16A34A);
      case 'sufficient':          return const Color(0xFF2563EB);
      case 'slightly sufficient': return const Color(0xFFD97706);
      case 'not sufficient':      return const Color(0xFFDC2626);
      default:                    return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF187B4D)),
      );
    }

    if (_recentResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.landscape_outlined,
                size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No field records yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade400,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Scan a soil sample to get started',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade400,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Recents Header ──
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.01,
          ),
          child: Text(
            'Recents',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: screenWidth * 0.04,
              color: Colors.black,
            ),
          ),
        ),

        // ── List ──
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            itemCount: _recentResults.length,
            itemBuilder: (context, index) {
              final result = _recentResults[index];
              final predColor = _getPredictionColor(result.prediction);

              return Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(color: Color(0xFFE8E9E9)),
                  ),
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: screenWidth * 0.09,
                              height: screenWidth * 0.09,
                              decoration: BoxDecoration(
                                color: predColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10.89),
                              ),
                              child: Icon(
                                Icons.grass,
                                size: screenWidth * 0.05,
                                color: predColor,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: Text(
                                result.farmName,
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'SOM : ${result.prediction}\npH    : ${result.phLevel} (${result.phStatus})\n${result.date}',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF908BA6),
                            height: 1.67,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'View details',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Icon(
                              Icons.arrow_downward,
                              size: screenWidth * 0.045,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// CAMERA VIEW WIDGET
// ─────────────────────────────────────────
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