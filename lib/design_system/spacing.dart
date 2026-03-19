import 'package:flutter/material.dart';

/// Yendo Design System — Spacing Tokens
///
/// Based on a 4px base unit. Every space in the app should come from here.
/// This keeps all padding, gaps, and margins consistent across screens.
///
/// Usage:
///   padding: EdgeInsets.all(AppSpacing.md)            → 16px
///   SizedBox(height: AppSpacing.lg)                   → 24px
///   padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding)
///
/// Quick reference:
///   xxs =  4px   — icon gap, tight inline spacing
///   xs  =  8px   — small gaps between related elements
///   sm  = 12px   — compact padding inside components
///   md  = 16px   — default padding, standard gaps
///   lg  = 24px   — section spacing, card padding
///   xl  = 32px   — large section gaps
///   xxl = 40px   — page-level vertical rhythm
///   x3l = 48px   — hero sections, top of screen breathing room
///   x4l = 64px   — very large gaps, full-screen layouts

abstract class AppSpacing {
  AppSpacing._();

  // ── Base scale ─────────────────────────────────────────
  static const double xxs =  4;
  static const double xs  =  8;
  static const double sm  = 12;
  static const double md  = 16;
  static const double lg  = 24;
  static const double xl  = 32;
  static const double xxl = 40;
  static const double x3l = 48;
  static const double x4l = 64;

  // ── Semantic layout tokens ─────────────────────────────

  /// Default horizontal padding on full-width screens
  static const double screenPaddingH = 24;

  /// Reduced screen padding for screens < 360px wide
  static const double screenPaddingHSmall = 16;

  /// Vertical padding from safe area to first content
  static const double screenPaddingTop = 8;

  /// Space between a section title and its content
  static const double sectionTitleGap = 12;

  /// Vertical gap between sections on a page
  static const double sectionGap = 40;

  /// Space between form fields in a funnel
  static const double formFieldGap = 20;

  /// Padding inside card components
  static const double cardPaddingH = 20;
  static const double cardPaddingV = 16;

  /// Padding inside list rows
  static const double listRowPaddingV = 14;
  static const double listRowPaddingH = 16;

  /// Padding inside buttons (horizontal)
  static const double buttonPaddingH = 24;
  static const double buttonPaddingV = 12;
  static const double buttonPaddingVSmall = 8;

  // ── Border radii ───────────────────────────────────────

  /// Small radius — inputs, tags
  static const double radiusSm = 8;

  /// Medium radius — cards, containers
  static const double radiusMd = 12;

  /// Large radius — bottom sheets, modals
  static const double radiusLg = 16;

  /// Full pill radius — buttons, badges
  static const double radiusPill = 99;

  // ── Icon sizes ─────────────────────────────────────────
  static const double iconSm  = 16;
  static const double iconMd  = 20;
  static const double iconLg  = 24;
  static const double iconXl  = 32;

  // ── Helper: responsive horizontal screen padding ───────

  /// Returns the correct screen padding based on screen width.
  /// Use inside widgets with access to BuildContext.
  static double screenPadding(BuildContext context) {
    return MediaQuery.of(context).size.width < 360
        ? screenPaddingHSmall
        : screenPaddingH;
  }

  /// Returns responsive horizontal EdgeInsets for screen content.
  static EdgeInsets screenInsets(BuildContext context) {
    return EdgeInsets.symmetric(horizontal: screenPadding(context));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Convenience spacing widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Vertical spacer using the design token scale.
///
/// Usage:
///   VSpace.xs()   →  8px tall box
///   VSpace.md()   → 16px tall box
///   VSpace.lg()   → 24px tall box
class VSpace extends SizedBox {
  const VSpace.xxs({super.key}) : super(height: AppSpacing.xxs);
  const VSpace.xs({super.key})  : super(height: AppSpacing.xs);
  const VSpace.sm({super.key})  : super(height: AppSpacing.sm);
  const VSpace.md({super.key})  : super(height: AppSpacing.md);
  const VSpace.lg({super.key})  : super(height: AppSpacing.lg);
  const VSpace.xl({super.key})  : super(height: AppSpacing.xl);
  const VSpace.xxl({super.key}) : super(height: AppSpacing.xxl);
  const VSpace.x3l({super.key}) : super(height: AppSpacing.x3l);
  const VSpace.x4l({super.key}) : super(height: AppSpacing.x4l);
}

/// Horizontal spacer using the design token scale.
///
/// Usage:
///   HSpace.xs()   →  8px wide box
///   HSpace.md()   → 16px wide box
class HSpace extends SizedBox {
  const HSpace.xxs({super.key}) : super(width: AppSpacing.xxs);
  const HSpace.xs({super.key})  : super(width: AppSpacing.xs);
  const HSpace.sm({super.key})  : super(width: AppSpacing.sm);
  const HSpace.md({super.key})  : super(width: AppSpacing.md);
  const HSpace.lg({super.key})  : super(width: AppSpacing.lg);
  const HSpace.xl({super.key})  : super(width: AppSpacing.xl);
  const HSpace.xxl({super.key}) : super(width: AppSpacing.xxl);
  const HSpace.x3l({super.key}) : super(width: AppSpacing.x3l);
  const HSpace.x4l({super.key}) : super(width: AppSpacing.x4l);
}
