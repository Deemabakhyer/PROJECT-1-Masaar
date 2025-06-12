import 'package:flutter/material.dart';
// import 'package:masaar/views/home_page.dart';

// Main App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavBar(),
    );
  }
}

// BottomNavBar Scaffold
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    // put your pages here
    // HomePage(),
    // Ridepage(),
    // AccountPage(),
  ];

  final List<Map<String, dynamic>> _navItems = [
    {"icon": Icons.home, "label": "Home"},
    {"icon": Icons.event_available, "label": "Ride"},
    {"icon": Icons.person, "label": "Account"},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      //same as bottom sheet
      bottomNavigationBar: Container(
        height: 120, // Set height here
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.25,
              ), // 25% visible (75% transparent)
              offset: Offset(0, -2), // 👈 Shadow above
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_navItems.length, (index) {
            bool isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _navItems[index]["icon"],
                    color: isSelected ? Colors.black : const Color(0xFF919191),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _navItems[index]["label"],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'inter',
                      color:
                          isSelected ? Colors.black : const Color(0xFF919191),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
