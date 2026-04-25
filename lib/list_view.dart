// list_view.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'homescreen_page.dart';
import 'cam_open.dart';

class ListViewWidget extends StatefulWidget {
  const ListViewWidget({super.key});

  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  List<SoilResult> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    setState(() => _isLoading = true);
    final results = await DatabaseHelper.instance.getAllResults();
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  Future<void> _deleteResult(int id) async {
    await DatabaseHelper.instance.deleteResult(id);
    _loadResults();
  }

  // ── Popup on image tap ──
  void _showResultPopup(BuildContext context, SoilResult result) {
    final Color predColor = _getPredictionColor(result.prediction);
    final String predEmoji = _getPredictionEmoji(result.prediction);
    final double confidence = double.tryParse(result.confidence) ?? 0.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ── Handle ──
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // ── Image ──
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xFFD9D9D9),
              ),
              clipBehavior: Clip.antiAlias,
              child: result.imagePath.isNotEmpty &&
                  File(result.imagePath).existsSync()
                  ? Image.file(File(result.imagePath), fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 40, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              result.date,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF71717A),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),

            // ── SOM Prediction ──
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              decoration: BoxDecoration(
                color: predColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border:
                Border.all(color: predColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Text(predEmoji,
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.prediction,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: predColor,
                          ),
                        ),
                        const Text(
                          'SOM Classification',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF71717A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${confidence.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: predColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ── Confidence Bar ──
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Confidence',
                      style: TextStyle(
                          fontSize: 11, color: Color(0xFF71717A)),
                    ),
                    Text(
                      '${confidence.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: predColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (confidence / 100).clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: const Color(0xFFF4F4F5),
                    valueColor:
                    AlwaysStoppedAnimation<Color>(predColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── pH Info ──
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.water_drop,
                      size: 18, color: Color(0xFF2563EB)),
                  const SizedBox(width: 8),
                  Text(
                    'pH Level: ${result.phLevel} — ${result.phStatus}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF09090B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ── Coffee Suitability ──
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: result.isSuitable
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(
                    result.isSuitable ? '☕' : '⚠️',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      result.isSuitable
                          ? 'Angkop para sa coffee cultivation sa Amadeo'
                          : 'Hindi pa angkop para sa coffee cultivation',
                      style: TextStyle(
                        color: result.isSuitable
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFC62828),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Close Button ──
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Color(0xFFE0E0E0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            // ── Add Field Button ──
            const SizedBox(height: 16),
            Container(
              width: 364,
              height: 36,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Add Field',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Content ──
            Expanded(
              child: _isLoading
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF187B4D),
                ),
              )
                  : _results.isEmpty
                  ? _buildEmptyState()
                  : _buildGalleryGrid(),
            ),

            // ── Bottom Nav ──
            _buildBottomNav(context),
          ],
        ),
      ),
    );
  }

  // ── Empty State ──
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.landscape_outlined,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No saved results yet',
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

  // ── Gallery Grid ──
  Widget _buildGalleryGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemCount: _results.length,
        itemBuilder: (context, index) {
          return _buildGalleryCard(_results[index]);
        },
      ),
    );
  }

  // ── Gallery Card ──
  Widget _buildGalleryCard(SoilResult result) {
    final Color predColor = _getPredictionColor(result.prediction);
    final String predEmoji = _getPredictionEmoji(result.prediction);

    return GestureDetector(
      onTap: () => _showResultPopup(context, result),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Image ──
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: result.imagePath.isNotEmpty &&
                    File(result.imagePath).existsSync()
                    ? Image.file(
                  File(result.imagePath),
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Container(
                  color: const Color(0xFFD9D9D9),
                  child: const Center(
                    child: Icon(Icons.image,
                        size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),

            // ── Info ──
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(predEmoji,
                          style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          result.prediction,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            color: predColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'pH ${result.phLevel} • ${result.date}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: Color(0xFF71717A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Nav (functional) ──
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      width: 396,
      height: 83,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavItem(
            context,
            icon: Icons.home,
            label: 'Home',
            isActive: false,
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeScreenPage(initialIndex: 0),
              ),
                  (route) => false,
            ),
          ),
          _buildNavItem(
            context,
            icon: Icons.camera_alt,
            label: 'Cam',
            isActive: false,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CamOpen()),
            ),
          ),
          _buildNavItem(
            context,
            icon: Icons.menu_book,
            label: 'List',
            isActive: true,
            onTap: () {}, // already here
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required bool isActive,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 83.37,
        height: 85.5,
        child: Column(
          children: [
            if (isActive)
              Container(width: 83, height: 4, color: const Color(0xFF187B4D))
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
              style: TextStyle(
                fontSize: 12.8,
                fontWeight: FontWeight.w300,
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

  // ─────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────
  Color _getPredictionColor(String prediction) {
    switch (prediction.toLowerCase()) {
      case 'highly sufficient':   return const Color(0xFF16A34A);
      case 'sufficient':          return const Color(0xFF2563EB);
      case 'slightly sufficient': return const Color(0xFFD97706);
      case 'not sufficient':      return const Color(0xFFDC2626);
      default:                    return Colors.grey;
    }
  }

  String _getPredictionEmoji(String prediction) {
    switch (prediction.toLowerCase()) {
      case 'highly sufficient':   return '🟢';
      case 'sufficient':          return '🔵';
      case 'slightly sufficient': return '🟡';
      case 'not sufficient':      return '🔴';
      default:                    return '⚪';
    }
  }
}