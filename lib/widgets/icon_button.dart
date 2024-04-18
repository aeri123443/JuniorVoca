import 'package:flutter/material.dart';
import 'package:juniorvoca/styles/colors.dart';

class LargeIconButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;

  const LargeIconButton({
    super.key,
    required this.icon,
    this.iconSize = 150,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1/1, 
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 8,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: IconButton(
          color: AppColors.textSecondary,
          icon: Icon(icon),
          padding: EdgeInsets.zero, // 패딩 설정
          iconSize: iconSize,
          onPressed: (){
          },
        ),
      ),
    );
  }
}
