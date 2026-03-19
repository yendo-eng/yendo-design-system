import 'package:flutter/material.dart';
import 'colors.dart';

/// Yendo Design System — Typography
///
/// Primary font: PP Neue Montreal
/// Make sure the font is added to pubspec.yaml and the assets/fonts folder.
class AppTextStyles {
  AppTextStyles._();

  // ── Button Labels ──────────────────────────────────────
  static const TextStyle buttonDefault = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 14,
    height: 1.14, // 16px line-height / 14px font-size
    letterSpacing: 0,
    color: AppColors.white,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.14,
    letterSpacing: 0,
    color: AppColors.white,
  );

  // ── Link Styles ────────────────────────────────────────
  static const TextStyle linkLarge = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.43, // 20px / 14px
    decoration: TextDecoration.underline,
    color: AppColors.navy,
  );

  static const TextStyle linkSmall = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w600,
    fontSize: 12,
    height: 1.5, // 18px / 12px
    decoration: TextDecoration.underline,
    color: AppColors.navy,
  );

  // ── Body ───────────────────────────────────────────────
  static const TextStyle bodyRegular = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
    color: AppColors.navy,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.43,
    color: AppColors.navy,
  );

  // ── Headings ───────────────────────────────────────────
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w700,
    fontSize: 56,
    height: 1.14,
    color: AppColors.navy,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w700,
    fontSize: 40,
    height: 1.2,
    color: AppColors.navy,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w600,
    fontSize: 24,
    height: 1.33,
    color: AppColors.navy,
  );
}
