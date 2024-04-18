import 'package:flutter/material.dart';
import 'package:juniorvoca/styles/colors.dart';

class ImageCard extends StatelessWidget {
  final String imagePath;

  const ImageCard({
    super.key, 
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 215,
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
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Image.asset(imagePath),
      ),
    );
  }
}
