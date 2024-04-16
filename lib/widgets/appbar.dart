import 'package:flutter/material.dart';
import 'package:juniorvoca/styles/colors.dart';

class JuvoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const JuvoAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Junior Voca'),
      backgroundColor: AppColors.backgroundPrimary,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // 설정 버튼을 누르면 설정 화면으로 이동하는 기능을 추가.
          },
        ),
      ],
    );
  }
}
