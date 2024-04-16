import 'package:flutter/material.dart';
import 'package:juniorvoca/styles/colors.dart';
import 'package:juniorvoca/styles/theme.dart';

class BuildStudyArea extends StatelessWidget{
  final String title;

  const BuildStudyArea({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTheme.body,
        ),
      ),
    );
  }
}
