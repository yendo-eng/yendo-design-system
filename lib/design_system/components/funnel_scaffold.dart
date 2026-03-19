import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';
import 'app_nav_bar.dart';
import 'app_progress_bar.dart';
import 'app_button.dart';

/// Yendo Design System — FunnelScaffold
///
/// A full-screen layout for application funnel steps.
/// Combines AppNavBar + optional progress bar + scrollable content + sticky bottom button.
///
/// Example usage:
///   FunnelScaffold(
///     currentStep: 2,
///     totalSteps: 6,
///     onBack: () => Navigator.pop(context),
///     onClose: () => Navigator.popUntil(context, (r) => r.isFirst),
///     primaryButtonLabel: 'Continue',
///     onPrimaryButtonPressed: _onContinue,
///     child: Column(
///       children: [
///         FunnelStepHeader(
///           title: 'What\'s your name?',
///           subtitle: 'Enter your legal name as it appears on your ID.',
///         ),
///         AppTextField(label: 'First name', hint: 'e.g. Jane'),
///         AppTextField(label: 'Last name', hint: 'e.g. Smith'),
///       ],
///     ),
///   )

class FunnelScaffold extends StatelessWidget {
  const FunnelScaffold({
    super.key,
    required this.child,
    this.currentStep,
    this.totalSteps,
    this.title,
    this.onBack,
    this.onClose,
    this.showBackButton = true,
    this.primaryButtonLabel,
    this.onPrimaryButtonPressed,
    this.secondaryButtonLabel,
    this.onSecondaryButtonPressed,
    this.showProgressBar = true,
    this.backgroundColor = AppColors.neutralN50,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.bottomPadding = 24,
  });

  /// The main content of the screen
  final Widget child;

  /// Used to render the progress bar. Pass null to hide.
  final int? currentStep;
  final int? totalSteps;

  /// Optional nav bar title
  final String? title;

  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final bool showBackButton;

  /// Primary (bottom) CTA button
  final String? primaryButtonLabel;
  final VoidCallback? onPrimaryButtonPressed;

  /// Optional secondary button (shown above primary)
  final String? secondaryButtonLabel;
  final VoidCallback? onSecondaryButtonPressed;

  final bool showProgressBar;
  final Color backgroundColor;
  final EdgeInsets padding;
  final double bottomPadding;

  bool get _hasProgressBar =>
      showProgressBar && currentStep != null && totalSteps != null;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsivePadding = padding != const EdgeInsets.symmetric(horizontal: 24)
        ? padding
        : EdgeInsets.symmetric(horizontal: screenWidth < 360 ? 16 : 24);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Nav bar ─────────────────────────────────────
            AppNavBar(
              title: title,
              onBack: onBack,
              onClose: onClose,
              showBackButton: showBackButton,
              backgroundColor: backgroundColor,
            ),

            // ── Progress bar ─────────────────────────────────
            if (_hasProgressBar)
              AppProgressBar(
                currentStep: currentStep!,
                totalSteps: totalSteps!,
              ),

            // ── Scrollable content ───────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: responsivePadding.copyWith(top: 8, bottom: 24),
                child: child,
              ),
            ),

            // ── Sticky bottom buttons ────────────────────────
            if (primaryButtonLabel != null)
              _BottomButtonArea(
                primaryLabel: primaryButtonLabel!,
                onPrimary: onPrimaryButtonPressed,
                secondaryLabel: secondaryButtonLabel,
                onSecondary: onSecondaryButtonPressed,
                bottomPadding: bottomPadding,
                backgroundColor: backgroundColor,
              ),
          ],
        ),
      ),
    );
  }
}

// ── Sticky bottom button area ──────────────────────────────

class _BottomButtonArea extends StatelessWidget {
  const _BottomButtonArea({
    required this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.bottomPadding = 24,
    this.backgroundColor = AppColors.neutralN50,
  });

  final String primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final double bottomPadding;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        bottomPadding + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            label: primaryLabel,
            onPressed: onPrimary,
            isFullWidth: true,
          ),
          if (secondaryLabel != null) ...[
            const SizedBox(height: 12),
            AppButton(
              label: secondaryLabel!,
              onPressed: onSecondary,
              variant: AppButtonVariant.tertiary,
              isFullWidth: true,
            ),
          ],
        ],
      ),
    );
  }
}

// ── FunnelStepHeader ───────────────────────────────────────

/// The large title + subtitle used at the top of each funnel step.
///
/// Example:
///   FunnelStepHeader(
///     title: 'What\'s your address?',
///     subtitle: 'Enter your current home address.',
///   )
class FunnelStepHeader extends StatelessWidget {
  const FunnelStepHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.bottomSpacing = 32,
  });

  final String title;
  final String? subtitle;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleSize = screenWidth < 360 ? 22.0 : 28.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: AppTextStyles.heading3.copyWith(
            fontSize: titleSize,
            fontWeight: FontWeight.w600,
            height: 1.28,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: AppTextStyles.bodyRegular.copyWith(
              color: AppColors.neutralN500,
              height: 1.5,
            ),
          ),
        ],
        SizedBox(height: bottomSpacing),
      ],
    );
  }
}
