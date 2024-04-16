import 'package:flutter/material.dart';
import 'package:juniorvoca/styles/colors.dart';

class AppTheme {
  static const primaryFont = "Pretendard";
  static const double primaryLetterSpacing = -0.8;

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 22,
    letterSpacing: primaryLetterSpacing,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineBold = TextStyle(
    fontFamily: primaryFont,
    fontSize: 22,
    letterSpacing: primaryLetterSpacing,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

    static const TextStyle titleMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20,
    letterSpacing: primaryLetterSpacing,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    letterSpacing: primaryLetterSpacing,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLight = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    letterSpacing: primaryLetterSpacing,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle subText = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    letterSpacing: primaryLetterSpacing,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

    static const TextStyle subText2 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    letterSpacing: primaryLetterSpacing,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );
}
