import 'package:flutter/material.dart';

// Main ListView Component
class ListViewWidget extends StatelessWidget {
  const ListViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top status bar
            const TopStatusBar(),
            const SizedBox(height: 16),

            // Add Field Button
            const AddFieldButton(),
            const SizedBox(height: 16),

            // Field Summary List Section
            const FieldSummaryListSection(),

            // Bottom Navigation
            const BottomNavigationSection(),
          ],
        ),
      ),
    );
  }
}

// Top Status Bar Component (Simplified - no images)
class TopStatusBar extends StatelessWidget {
  const TopStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 413,
      height: 48.46,
      margin: const EdgeInsets.symmetric(horizontal: 8.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29.74),
      ),
    );
  }
}

// Add Field Button Component
class AddFieldButton extends StatelessWidget {
  const AddFieldButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Plus icon as an Icon instead of image asset
          const Icon(
            Icons.add,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          const Text(
            'Add Field',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// Field Summary Model
class FieldSummary {
  final int id;
  final String fieldName;
  final String date;
  final String time;
  final String soilMoisture;
  final String phLevel;
  final FieldStatus status;

  const FieldSummary({
    required this.id,
    required this.fieldName,
    required this.date,
    required this.time,
    required this.soilMoisture,
    required this.phLevel,
    required this.status,
  });
}

enum FieldStatus {
  good,
  bad,
  neutral,
}

extension FieldStatusExtension on FieldStatus {
  String get displayName {
    switch (this) {
      case FieldStatus.good:
        return 'Good';
      case FieldStatus.bad:
        return 'Bad';
      case FieldStatus.neutral:
        return 'Neutral';
    }
  }
}

// Field Summary List Section
class FieldSummaryListSection extends StatelessWidget {
  const FieldSummaryListSection({super.key});

  // Sample data
  static const List<FieldSummary> fieldSummariesData = [
    FieldSummary(
      id: 1,
      fieldName: 'Field 3 - North Side',
      date: 'October 20, 2025',
      time: '10:00 AM',
      soilMoisture: '4.2 % SOM',
      phLevel: 'Neutral PH level',
      status: FieldStatus.good,
    ),
    FieldSummary(
      id: 2,
      fieldName: 'Field 3 - North Side',
      date: 'October 20, 2025',
      time: '10:00 AM',
      soilMoisture: '4.2 % SOM',
      phLevel: 'Neutral PH level',
      status: FieldStatus.good,
    ),
    FieldSummary(
      id: 3,
      fieldName: 'Field 3 - North Side',
      date: 'October 20, 2025',
      time: '10:00 AM',
      soilMoisture: '4.2 % SOM',
      phLevel: 'Neutral PH level',
      status: FieldStatus.good,
    ),
    FieldSummary(
      id: 4,
      fieldName: 'Field 3 - North Side',
      date: 'October 20, 2025',
      time: '10:00 AM',
      soilMoisture: '4.2 % SOM',
      phLevel: 'Neutral PH level',
      status: FieldStatus.good,
    ),
    FieldSummary(
      id: 5,
      fieldName: 'Field 3 - North Side',
      date: 'October 20, 2025',
      time: '10:00 AM',
      soilMoisture: '4.2 % SOM',
      phLevel: 'Neutral PH level',
      status: FieldStatus.good,
    ),
  ];

  static const List<FieldStatus> statusOptions = [
    FieldStatus.good,
    FieldStatus.bad,
    FieldStatus.neutral,
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 396,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (int index = 0; index < fieldSummariesData.length; index++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: index == fieldSummariesData.length - 1 ? 0 : 8,
                    ),
                    child: _FieldSummaryCard(
                      summary: fieldSummariesData[index],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Field Summary Card Component
class _FieldSummaryCard extends StatelessWidget {
  final FieldSummary summary;

  const _FieldSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with field name and date
          Row(
            children: [
              Expanded(
                child: Text(
                  summary.fieldName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF18181B),
                  ),
                ),
              ),
              Text(
                summary.date,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF18181B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Time
          Text(
            summary.time,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF71717A),
            ),
          ),
          const SizedBox(height: 8),
          // Description (Soil Moisture and PH Level)
          Text(
            '${summary.soilMoisture}\n${summary.phLevel}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF71717A),
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          // Status buttons and Edit Info button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status options
              Row(
                children: FieldSummaryListSection.statusOptions.map((status) {
                  final isActive = summary.status == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.black : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        status.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isActive ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              // Edit Info button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'Edit Info',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF18181B),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Bottom Navigation Section
class BottomNavigationSection extends StatelessWidget {
  const BottomNavigationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 396,
      height: 83,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Home Tab
          _BottomNavItem(
            label: 'Home',
            icon: Icons.home_outlined,
            isActive: true,
            onTap: () {},
          ),
          // Camera Tab
          _BottomNavItem(
            label: 'Cam',
            icon: Icons.camera_alt_outlined,
            isActive: false,
            onTap: () {},
          ),
          // List Tab
          _BottomNavItem(
            label: 'List',
            icon: Icons.book_outlined,
            isActive: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// Bottom Navigation Item Component
class _BottomNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 83.37,
        height: 85.5,
        child: Column(
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
              color: isActive ? const Color(0xFF187B4D) : Colors.black54,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.8,
                fontWeight: FontWeight.w300,
                color: isActive ? Colors.black : Colors.black.withOpacity(0.5),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}