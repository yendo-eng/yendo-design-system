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

  // ── Headings (legacy) ──────────────────────────────────
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

  // ── H scale (from YendoFont) ───────────────────────────
  static const TextStyle h0 = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w700,
    fontSize: 48,
    height: 1.33,
    letterSpacing: -1,
    color: AppColors.navy,
  );

  static const TextStyle h1 = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w700,
    fontSize: 32,
    height: 1.25,
    letterSpacing: 0,
    color: AppColors.navy,
  );

  /// 24px bold — matches Figma "title/large 24" at bold weight.
  /// Use .copyWith(fontWeight: FontWeight.w600) for semibold,
  /// or .copyWith(fontWeight: FontWeight.w500) for medium.
  static const TextStyle h2 = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.navy,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.navy,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.navy,
  );

  // ── Sub-headings (from YendoFont) ──────────────────────
  static const TextStyle subHeading0 = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w500,
    fontSize: 24,
    height: 1.33,
    letterSpacing: 0.5,
    color: AppColors.navy,
  );

  static const TextStyle subHeading1 = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w500,
    fontSize: 20,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.navy,
  );

  static const TextStyle subHeading2 = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.navy,
  );

  static const TextStyle subHeading3 = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.navy,
  );

  // ── Body (from YendoFont) ──────────────────────────────
  static const TextStyle body1 = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.neutralN600,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.neutralN500,
  );

  // ── Caption / Overline / Label / Legend ────────────────
  static const TextStyle caption = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.neutralN500,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 1.6,
    letterSpacing: 1.5,
    color: AppColors.neutralN600,
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 1.6,
    letterSpacing: 0,
    color: AppColors.neutralN500,
  );

  static const TextStyle legend = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0,
    color: AppColors.neutralN500,
  );

  // ── Link ───────────────────────────────────────────────
  static const TextStyle link = TextStyle(
    fontFamily: 'PPNeueMontreal',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.darkBlue,
    decoration: TextDecoration.underline,
  );
}
