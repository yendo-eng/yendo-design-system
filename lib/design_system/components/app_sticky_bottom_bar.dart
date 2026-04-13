import 'package:flutter/material.dart';
import '../colors.dart';
import '../spacing.dart';
import 'app_button.dart';

/// Yendo Design System — AppStickyBottomBar
///
/// A sticky bottom action area that sits above the safe area.
/// Supports a primary button, optional secondary button, and
/// optional footnote text (e.g. legal copy or helper links).
///
/// Usage:
///   Scaffold(
///     body: Column(
///       children: [
///         Expanded(child: SingleChildScrollView(...)),
///         AppStickyBottomBar(
///           primaryLabel: 'Continue',
///           onPrimary: () {},
///           secondaryLabel: 'Compare offers',
///           secondaryVariant: AppButtonVariant.link,
///           onSecondary: () {},
///         ),
///       ],
///     ),
///   )

class AppStickyBottomBar extends StatelessWidget {
  const AppStickyBottomBar({
    super.key,
    required this.primaryLabel,
    this.onPrimary,
    this.primaryVariant = AppButtonVariant.primary,
    this.secondaryLabel,
    this.onSecondary,
    this.secondaryVariant = AppButtonVariant.link,
    this.footnote,
    this.backgroundColor,
    this.showTopDivider = true,
    this.topPadding,
  });

  final String primaryLabel;
  final VoidCallback? onPrimary;
  final AppButtonVariant primaryVariant;

  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final AppButtonVariant secondaryVariant;

  /// Optional small text below the buttons (legal copy, helper text)
  final String? footnote;

  /// Defaults to scaffold background color
  final Color? backgroundColor;

  /// Thin divider line at the top of the bar
  final bool showTopDivider;

  /// Override the top padding inside the bar (defaults to AppSpacing.xl = 32)
  final double? topPadding;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ??
        Theme.of(context).scaffoldBackgroundColor;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      color: bg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showTopDivider)
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.neutralN100,
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPaddingH,
              topPadding ?? AppSpacing.md,
              AppSpacing.screenPaddingH,
              bottomPadding > 0
                  ? bottomPadding + AppSpacing.xs
                  : AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Primary button
                AppButton(
                  label: primaryLabel,
                  onPressed: onPrimary,
                  variant: primaryVariant,
                  isFullWidth: true,
                ),

                // Secondary button
                if (secondaryLabel != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  if (secondaryVariant == AppButtonVariant.link)
                    Center(
                      child: AppButton(
                        label: secondaryLabel!,
                        onPressed: onSecondary,
                        variant: secondaryVariant,
                      ),
                    )
                  else
                    AppButton(
                      label: secondaryLabel!,
                      onPressed: onSecondary,
                      variant: secondaryVariant,
                      isFullWidth: true,
                    ),
                ],

                // Footnote
                if (footnote != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    footnote!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'PPNeueMontreal',
                      fontSize: 11,
                      color: AppColors.neutralN500,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
