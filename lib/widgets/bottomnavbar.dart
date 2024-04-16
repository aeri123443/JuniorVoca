import 'package:flutter/material.dart';
import 'package:juniorvoca/styles/colors.dart';

class JuvoBottomNavBar extends StatelessWidget {
  const JuvoBottomNavBar({super.key,});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.backgroundPrimary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: '언어 추가',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '설정',
        ),
      ],
    );
  }
}
