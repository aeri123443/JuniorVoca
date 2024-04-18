import 'package:flutter/material.dart';
import 'package:juniorvoca/styles/colors.dart';

class AppTheme {
  static const primaryFont = "Pretendard";
  static const double primaryLetterSpacing = -0.8;

    static const TextStyle headline1Bold = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32,
    letterSpacing: primaryLetterSpacing,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
  );

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
    fontSize: 22,
    letterSpacing: primaryLetterSpacing,
    fontWeight: FontWeight.w800,
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

  static const TextStyle caption = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    letterSpacing: primaryLetterSpacing,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

    static const TextStyle caption2 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    letterSpacing: primaryLetterSpacing,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );
}
