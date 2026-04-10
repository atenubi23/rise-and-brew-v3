import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'list_view.dart';  // Import your list_view

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rise & Brew',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _top;
  late Animation<double> _left;
  late Animation<double> _width;
  late Animation<double> _height;
  late Animation<double> _borderRadius;
  late Animation<double> _rotation;
  late Animation<double> _opacity;

  static const double designWidth = 412;
  static const double designHeight = 917;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _top = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 408, end: 374.4), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 374.4, end: 412.6), weight: 1),
      TweenSequenceItem(tween: ConstantTween<double>(412.6), weight: 2),
    ]).animate(_controller);

    _left = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 156, end: 115.4), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 115.4, end: 151.6), weight: 1),
      TweenSequenceItem(tween: ConstantTween<double>(151.6), weight: 2),
    ]).animate(_controller);

    _width = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 100, end: 167.08), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 167.08, end: 99.89), weight: 1),
      TweenSequenceItem(tween: ConstantTween<double>(99.89), weight: 2),
    ]).animate(_controller);
    _height = _width;

    _borderRadius = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 25, end: 41.77), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 41.77, end: 72), weight: 1),
      TweenSequenceItem(tween: ConstantTween<double>(72), weight: 2),
    ]).animate(_controller);

    _rotation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -48.32), weight: 1),
      TweenSequenceItem(tween: ConstantTween<double>(-48.32), weight: 3),
    ]).animate(_controller);
    _rotation = _rotation.drive(Tween<double>(begin: 0, end: -48.32 * 3.14159 / 180));

    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 3),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 1),
    ]).animate(_controller);

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        // Navigate to ListViewWidget instead of GalleryAccess
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ListViewWidget()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scaleX = screenWidth / designWidth;
    final scaleY = screenHeight / designHeight;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Positioned(
                    top: _top.value * scaleY,
                    left: _left.value * scaleX,
                    child: Opacity(
                      opacity: _opacity.value,
                      child: Transform.rotate(
                        angle: _rotation.value,
                        child: Container(
                          width: _width.value * scaleX,
                          height: _height.value * scaleY,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(_borderRadius.value * scaleX),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF187B4D), Colors.white],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final showText = _controller.value >= 0.8;
                  final textOpacity = showText
                      ? ((_controller.value - 0.8) / 0.2).clamp(0.0, 1.0)
                      : 0.0;
                  return Opacity(
                    opacity: textOpacity,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'RISE & BREW',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 40.7 * scaleX,
                              color: Colors.white,
                              letterSpacing: 0,
                            ),
                          ),
                          SizedBox(width: 14.5 * scaleX),
                          Transform.rotate(
                            angle: -48.32 * 3.14159 / 180,
                            child: Container(
                              width: 31.76 * scaleX,
                              height: 31.76 * scaleX,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22.89 * scaleX),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xFF187B4D), Colors.white],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}