// list_view.dart
import 'package:flutter/material.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  int _selectedBottomNavIndex = 2; // List tab selected
  late List<FieldCard> _cards;

  @override
  void initState() {
    super.initState();
    _cards = fieldCardsData.map((data) => FieldCard.fromJson(data)).toList();
  }

  void _updateCardStatus(int cardId, StatusType newStatus) {
    setState(() {
      final index = _cards.indexWhere((card) => card.id == cardId);
      if (index != -1) {
        _cards[index].activeStatus = newStatus;
      }
    });
  }

  void _onAddField() {
    // TODO: Navigate to add field screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Field tapped')),
    );
  }

  void _onEditInfo(FieldCard card) {
    // TODO: Navigate to edit info screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit Info for ${card.title}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top spacing (status bar placeholder)
            const SizedBox(height: 12),
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Add Field button
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: ElevatedButton.icon(
                        onPressed: _onAddField,
                        icon: const Icon(Icons.add, size: 16, color: Colors.white),
                        label: const Text(
                          'Add Field',
                          style: TextStyle(
                            fontFamily: 'Geist',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Field cards list
                    ..._cards.map((card) => _buildFieldCard(card)),
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
            // Navigate to Cam
          } else if (index == 2) {
            // Already on List
          }
        },
      ),
    );
  }

  Widget _buildFieldCard(FieldCard card) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E4E7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            card.title,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF09090B),
                            ),
                          ),
                        ),
                        Text(
                          card.date,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xFF09090B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.time,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Color(0xFF71717A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      card.description,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xFF71717A),
                        height: 1.4,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status buttons (Good, Bad, Neutral)
              Row(
                children: StatusType.values.map((status) {
                  final isActive = card.activeStatus == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => _updateCardStatus(card.id, status),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.black : const Color(0xFFF4F4F5),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          status.toString().split('.').last,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: isActive ? Colors.white : const Color(0xFF18181B),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              // Edit Info button
              GestureDetector(
                onTap: () => _onEditInfo(card),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Edit Info',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF18181B),
                    ),
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

// Data models
enum StatusType { Good, Bad, Neutral }

class FieldCard {
  final int id;
  final String title;
  final String date;
  final String time;
  final String description;
  StatusType activeStatus;

  FieldCard({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    required this.activeStatus,
  });

  factory FieldCard.fromJson(Map<String, dynamic> json) {
    return FieldCard(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      time: json['time'],
      description: json['description'],
      activeStatus: StatusType.values.firstWhere(
            (e) => e.toString().split('.').last == json['activeStatus'],
      ),
    );
  }
}

// Sample data (matching the React example)
final List<Map<String, dynamic>> fieldCardsData = [
  {
    'id': 1,
    'title': 'Field 3 - North Side',
    'date': 'October 20, 2025',
    'time': '10:00 AM',
    'description': '4.2 % SOM\nNeutral PH level',
    'activeStatus': 'Good',
  },
  {
    'id': 2,
    'title': 'Field 3 - North Side',
    'date': 'October 20, 2025',
    'time': '10:00 AM',
    'description': '4.2 % SOM\nNeutral PH level',
    'activeStatus': 'Good',
  },
  {
    'id': 3,
    'title': 'Field 3 - North Side',
    'date': 'October 20, 2025',
    'time': '10:00 AM',
    'description': '4.2 % SOM\nNeutral PH level',
    'activeStatus': 'Good',
  },
  {
    'id': 4,
    'title': 'Field 3 - North Side',
    'date': 'October 20, 2025',
    'time': '10:00 AM',
    'description': '4.2 % SOM\nNeutral PH level',
    'activeStatus': 'Good',
  },
  {
    'id': 5,
    'title': 'Field 3 - North Side',
    'date': 'October 20, 2025',
    'time': '10:00 AM',
    'description': '4.2 % SOM\nNeutral PH level',
    'activeStatus': 'Bad',
  },
];