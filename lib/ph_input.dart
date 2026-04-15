// ph_input.dart
import 'package:flutter/material.dart';
import 'result_page.dart'; // Import the result page

class PhInputPage extends StatefulWidget {
  const PhInputPage({super.key});

  @override
  State<PhInputPage> createState() => _PhInputPageState();
}

class _PhInputPageState extends State<PhInputPage> {
  final TextEditingController _phController = TextEditingController();
  String _selectedStatus = 'strongly-acidic';
  int _selectedBottomNavIndex = 1; // Cam is selected (index 1)

  final List<Map<String, String>> _statusOptions = [
    {'label': 'Strongly Acidic (0-3)', 'value': 'strongly-acidic'},
    {'label': 'Weakly Acidic (4-6.9)', 'value': 'weakly-acidic'},
    {'label': 'Neutral (7)', 'value': 'neutral'},
    {'label': 'Strongly Alkaline (7.1 - 14)', 'value': 'strongly-alkaline'},
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

  void _onBackPressed() {
    Navigator.pop(context);
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onViewResults() {
    // Get pH value (default to empty string if not entered)
    String phValue = _phController.text.trim();
    if (phValue.isEmpty) {
      // Optionally show a warning
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a pH level')),
      );
      return;
    }

    // Navigate to ResultPage with the pH and status data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          phLevel: phValue,
          // You can also pass the status label if needed
          // soilType, somLevel, etc. can be passed later or use default values
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
                    GestureDetector(
                      onTap: _onBackPressed,
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
                                height: 20 / 14,
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
                            TextFormField(
                              controller: _phController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '0-14',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Geist',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xFF7F7F86),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                                  borderSide: const BorderSide(color: Color(0xFF187B4D), width: 1.5),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return null;
                                final ph = double.tryParse(value);
                                if (ph != null && (ph < 0 || ph > 14)) {
                                  return 'pH must be between 0 and 14';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
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
                                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF334155)),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                                            const Icon(Icons.check, size: 16, color: Color(0xFF187B4D)),
                                          const SizedBox(width: 8),
                                          Text(option['label']!),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedStatus = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Column(
                              children: [
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
                                      shadowColor: Colors.transparent,
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
                                    onPressed: _onCancel,
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
                              ],
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(0.5),
        selectedFontSize: 12.8,
        unselectedFontSize: 12.8,
        iconSize: 26,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Cam'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'List'),
        ],
        onTap: (index) {
          setState(() {
            _selectedBottomNavIndex = index;
          });
          if (index == 0) {
            // Navigate to Home
          } else if (index == 1) {
            // Already on Cam (this page)
          } else if (index == 2) {
            // Navigate to List
          }
        },
      ),
    );
  }
}