// result_page.dart
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String farmName;
  final String date;
  final String soilType;
  final String somLevel;
  final String phLevel;
  final String imageUrl; // optional, can be a local asset or network image

  const ResultPage({
    super.key,
    this.farmName = 'Amadeo farm : Field North',
    this.date = 'Oct. 28 2025',
    this.soilType = 'Tagaytay loam soil',
    this.somLevel = '4.2 %',
    this.phLevel = '6',
    this.imageUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Status bar placeholder (optional)
            const SizedBox(height: 12),
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
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
                    // Card + Save button container (using Column)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card
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
                              // Header row: farm name, date, and image
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          farmName,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Color(0xFF09090B),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          date,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Color(0xFF71717A),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Loam type : $soilType\nSOM level : $somLevel\npH Level : $phLevel',
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w300,
                                            fontSize: 13.7,
                                            letterSpacing: 0.14,
                                            height: 1.0,
                                            color: Color(0xFF71717A),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Placeholder image
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD9D9D9),
                                      borderRadius: BorderRadius.circular(50),
                                      image: imageUrl.isNotEmpty
                                          ? DecorationImage(
                                        image: NetworkImage(imageUrl),
                                        fit: BoxFit.cover,
                                      )
                                          : null,
                                    ),
                                    child: imageUrl.isEmpty
                                        ? const Center(
                                      child: Icon(Icons.image,
                                          size: 40, color: Colors.grey),
                                    )
                                        : null,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Tags (Good, Bad, Neutral)
                              Row(
                                children: [
                                  _buildTag('Good', active: true),
                                  const SizedBox(width: 8),
                                  _buildTag('Bad', active: false),
                                  const SizedBox(width: 8),
                                  _buildTag('Neutral', active: false),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // View details row
                              GestureDetector(
                                onTap: () {
                                  // TODO: Navigate to detailed analysis page
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('View details tapped')),
                                  );
                                },
                                child: const Row(
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
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 499), // Spacing to match original design
                        // Save button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Implement save to field logic
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Saved to Field')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Save to Field',
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
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

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1, // Cam is active (green top bar)
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
        if (index == 0) {
          // Navigate to Home
        } else if (index == 1) {
          // Already on camera-related flow
        } else if (index == 2) {
          // Navigate to List
        }
      },
    );
  }
}