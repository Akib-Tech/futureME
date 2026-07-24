import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          backgroundColor: AppColors.background,
          label: "Home",
          icon: const Icon(Icons.home, color: Colors.red),
        ),
        const BottomNavigationBarItem(
          label: "About",
          icon: Icon(Icons.home),
        ),
        const BottomNavigationBarItem(
          label: "COme",
          icon: Icon(Icons.home),
        ),
        const BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
        ),
      ],
    );
  }
}
