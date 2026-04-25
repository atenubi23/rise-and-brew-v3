// result_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'list_view.dart';

class ResultPage extends StatefulWidget {
  final String imagePath;
  final String prediction;
  final String confidence;
  final String phLevel;
  final String phStatus;
  final String date;
  final String farmName;

  const ResultPage({
    super.key,
    required this.imagePath,
    required this.prediction,
    required this.confidence,
    required this.phLevel,
    required this.phStatus,
    required this.date,
    this.farmName = 'Amadeo Farm : Field North',
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _isSaving = false;
  bool _isSaved = false;

  // ─────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────
  Color _getPredictionColor() {
    switch (widget.prediction.toLowerCase()) {
      case 'highly sufficient':   return const Color(0xFF16A34A);
      case 'sufficient':          return const Color(0xFF2563EB);
      case 'slightly sufficient': return const Color(0xFFD97706);
      case 'not sufficient':      return const Color(0xFFDC2626);
      default:                    return Colors.grey;
    }
  }

  String _getPredictionEmoji() {
    switch (widget.prediction.toLowerCase()) {
      case 'highly sufficient':   return '🟢';
      case 'sufficient':          return '🔵';
      case 'slightly sufficient': return '🟡';
      case 'not sufficient':      return '🔴';
      default:                    return '⚪';
    }
  }

  bool _isGoodForCoffee() {
    return widget.prediction.toLowerCase() == 'highly sufficient' ||
        widget.prediction.toLowerCase() == 'sufficient';
  }

  // ─────────────────────────────────────────
  // SUCCESS DIALOG
  // ─────────────────────────────────────────
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // ── X Close ──
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 20, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 4),

              // ── Check Icon ──
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF4CAF50),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF4CAF50),
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),

              // ── Title ──
              const Text(
                'Field Recorded Successfully!',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xFF09090B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // ── Subtitle ──
              const Text(
                'The soil scan result has been saved to your field records. You can view it anytime in the List.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: Color(0xFF71717A),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // ── View List Button ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ListViewWidget(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF187B4D),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'View List',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // SAVE TO FIELD
  // ─────────────────────────────────────────
  Future<void> _saveToField() async {
    if (_isSaved) return;
    setState(() => _isSaving = true);

    try {
      final result = SoilResult(
        farmName: widget.farmName,
        prediction: widget.prediction,
        confidence: widget.confidence,
        phLevel: widget.phLevel,
        phStatus: widget.phStatus,
        date: widget.date,
        imagePath: widget.imagePath,
        isSuitable: _isGoodForCoffee(),
      );

      await DatabaseHelper.instance.insertResult(result);

      if (!mounted) return;
      setState(() {
        _isSaved = true;
        _isSaving = false;
      });

      _showSuccessDialog(); // ← show dialog instead of snackbar

    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving: $e')),
      );
    }
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final predColor = _getPredictionColor();
    final predEmoji = _getPredictionEmoji();
    final double confidenceValue =
        double.tryParse(widget.confidence) ?? 0.0;
    final bool goodForCoffee = _isGoodForCoffee();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Back Button ──
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back, size: 20, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            'Back',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Main Card ──
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE4E4E7)),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // ── Header ──
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.farmName,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Color(0xFF09090B),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.date,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: Color(0xFF71717A),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'SOM Level : ${widget.prediction}\npH Level    : ${widget.phLevel} (${widget.phStatus})',
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13,
                                        height: 1.6,
                                        color: Color(0xFF71717A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),

                              // ── Image + Overlay ──
                              Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD9D9D9),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: widget.imagePath.isNotEmpty
                                        ? Image.file(
                                      File(widget.imagePath),
                                      fit: BoxFit.cover,
                                    )
                                        : const Center(
                                      child: Icon(Icons.image,
                                          size: 40, color: Colors.grey),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black
                                            .withValues(alpha: 0.65),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(50),
                                          bottomRight: Radius.circular(50),
                                        ),
                                      ),
                                      child: Text(
                                        '$predEmoji ${confidenceValue.toStringAsFixed(1)}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // ── Prediction Banner ──
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: predColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: predColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(predEmoji,
                                    style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.prediction,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: predColor,
                                        ),
                                      ),
                                      Text(
                                        'SOM Classification',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11,
                                          color: predColor
                                              .withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${confidenceValue.toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        color: predColor,
                                      ),
                                    ),
                                    Text(
                                      'confidence',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 10,
                                        color: predColor
                                            .withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // ── Confidence Bar ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Prediction Confidence',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF71717A),
                                ),
                              ),
                              Text(
                                '${confidenceValue.toStringAsFixed(1)}%',
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
                              value: (confidenceValue / 100).clamp(0.0, 1.0),
                              minHeight: 6,
                              backgroundColor: const Color(0xFFF4F4F5),
                              valueColor:
                              AlwaysStoppedAnimation<Color>(predColor),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ── Tags ──
                          Row(
                            children: [
                              _buildTag('Good', active: goodForCoffee),
                              const SizedBox(width: 8),
                              _buildTag('Bad',
                                  active: widget.prediction.toLowerCase() ==
                                      'not sufficient'),
                              const SizedBox(width: 8),
                              _buildTag('Neutral',
                                  active: widget.prediction.toLowerCase() ==
                                      'slightly sufficient'),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // ── View Details ──
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'View details',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_downward,
                                  size: 18, color: Colors.black),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Coffee Suitability ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color: goodForCoffee
                            ? const Color(0xFFE8F5E9)
                            : const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            goodForCoffee ? '☕' : '⚠️',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              goodForCoffee
                                  ? 'Angkop para sa coffee cultivation sa Amadeo'
                                  : 'Hindi pa angkop para sa coffee cultivation',
                              style: TextStyle(
                                color: goodForCoffee
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
                    const SizedBox(height: 24),

                    // ── Save Button ──
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaved || _isSaving ? null : _saveToField,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          _isSaved ? Colors.grey : Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          _isSaved ? '✓ Saved!' : 'Save to Field',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, {required bool active}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? Colors.black : const Color(0xFFF4F4F5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: active ? Colors.white : const Color(0xFF18181B),
        ),
      ),
    );
  }
}