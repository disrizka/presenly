import 'package:flutter/material.dart';
import 'package:presenly/pages/home/screens/home_screen.dart';
import 'package:presenly/pages/set/screens/settings_screen.dart';
import 'package:presenly/utils/constant/app_color.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [HomeScreen(), Placeholder(), SettingsScreen()];

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.backgroundColor,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: AppColor.primaryColor.withOpacity(0.5),
        showSelectedLabels: false, // <-- sembunyikan label
        showUnselectedLabels: false, // <-- sembunyikan label
        type: BottomNavigationBarType.fixed,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}
