import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Yendo Design System — Typography
///
/// Primary font: PP Neue Montreal
/// Secondary font: Space Grotesk (via google_fonts) — use for display headlines,
/// card amounts, or numeric callouts to add expressive personality.
///
/// Usage:
///   AppTextStyles.spaceGrotesk(fontSize: 32, fontWeight: FontWeight.w700)
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

  // ── Space Grotesk (secondary display font) ─────────────
  /// Returns a Space Grotesk TextStyle. Use for display numbers, hero
  /// headlines, or anywhere you want a more expressive, editorial feel.
  ///
  /// Example:
  ///   Text('\$10,000', style: AppTextStyles.spaceGrotesk(fontSize: 40))
  static TextStyle spaceGrotesk({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w700,
    Color color = AppColors.navy,
    double? height,
    double? letterSpacing,
  }) =>
      GoogleFonts.spaceGrotesk(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
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
