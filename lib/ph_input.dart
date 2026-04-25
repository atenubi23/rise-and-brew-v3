// ph_input.dart
import 'package:flutter/material.dart';
import 'result_page.dart';

class PhInputPage extends StatefulWidget {
  final String imagePath;
  final String prediction;
  final String confidence;

  const PhInputPage({
    super.key,
    required this.imagePath,
    required this.prediction,
    required this.confidence,
  });

  @override
  State<PhInputPage> createState() => _PhInputPageState();
}

class _PhInputPageState extends State<PhInputPage> {
  final TextEditingController _phController = TextEditingController();
  String _selectedStatus = 'strongly-acidic';
  int _selectedBottomNavIndex = 1;

  final List<Map<String, String>> _statusOptions = [
    {'label': 'Strongly Acidic (0-3)', 'value': 'strongly-acidic'},
    {'label': 'Weakly Acidic (4-6.9)', 'value': 'weakly-acidic'},
    {'label': 'Neutral (7)', 'value': 'neutral'},
    {'label': 'Strongly Alkaline (7.1-14)', 'value': 'strongly-alkaline'},
  ];

  String get _selectedStatusLabel {
    return _statusOptions.firstWhere(
          (opt) => opt['value'] == _selectedStatus,
      orElse: () => _statusOptions[0],
    )['label']!;
  }

  @override
  void dispose() {
    _phController.dispose();
    super.dispose();
  }

  // ── Auto-detect pH status based on typed value ──
  void _onPhChanged(String value) {
    final ph = double.tryParse(value);
    if (ph == null) return;

    String newStatus;
    if (ph <= 3) {
      newStatus = 'strongly-acidic';
    } else if (ph < 7) {
      newStatus = 'weakly-acidic';
    } else if (ph == 7) {
      newStatus = 'neutral';
    } else {
      newStatus = 'strongly-alkaline';
    }

    setState(() => _selectedStatus = newStatus);
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[now.month - 1]}. ${now.day} ${now.year}';
  }

  void _onViewResults() {
    final phValue = _phController.text.trim();
    if (phValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a pH level')),
      );
      return;
    }

    final ph = double.tryParse(phValue);
    if (ph == null || ph < 0 || ph > 14) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('pH must be between 0 and 14')),
      );
      return;
    }

    // ── Pass ALL real data to ResultPage ──
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(
          imagePath: widget.imagePath,
          prediction: widget.prediction,
          confidence: widget.confidence,
          phLevel: phValue,
          phStatus: _selectedStatusLabel,
          date: _getFormattedDate(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

                    // ── SOM Result Preview Banner ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF187B4D).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF187B4D),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'SOM Classification Done ✓',
                                  style: TextStyle(
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: Color(0xFF187B4D),
                                  ),
                                ),
                                Text(
                                  '${widget.prediction}  •  ${widget.confidence}% confidence',
                                  style: const TextStyle(
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Color(0xFF187B4D),
                                  ),
                                ),
                              ],
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
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: const Color(0xFFD9D9D9)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text(
                              'You\'re almost there! Please input the pH level of your soil for more accurate analysis.',
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                height: 1.4,
                                color: Color(0xFF09090B),
                              ),
                            ),
                            const SizedBox(height: 30),

                            const Text(
                              'Enter pH Level here :',
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF09090B),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // ── pH Text Field ──
                            TextFormField(
                              controller: _phController,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              onChanged: _onPhChanged,
                              decoration: InputDecoration(
                                hintText: '0 - 14',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Geist',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xFF7F7F86),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF187B4D),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // ── Status Dropdown (Auto) ──
                            const Text(
                              'Status (Auto)',
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFCBD5E1)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedStatus,
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xFF334155),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xFF334155),
                                  ),
                                  items: _statusOptions.map((option) {
                                    return DropdownMenuItem<String>(
                                      value: option['value'],
                                      child: Row(
                                        children: [
                                          if (_selectedStatus == option['value'])
                                            const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Color(0xFF187B4D),
                                            ),
                                          const SizedBox(width: 8),
                                          Text(option['label']!),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() => _selectedStatus = value!);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // ── Buttons ──
                            SizedBox(
                              width: double.infinity,
                              height: 36,
                              child: ElevatedButton(
                                onPressed: _onViewResults,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'View Results',
                                  style: TextStyle(
                                    fontFamily: 'Geist',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 36,
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF09090B),
                                  side: const BorderSide(color: Color(0xFFE0E0E0)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily: 'Geist',
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
            ),
          ],
        ),
      ),

    );
  }
}