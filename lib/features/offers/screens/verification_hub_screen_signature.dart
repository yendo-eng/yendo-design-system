import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../design_system/design_system.dart';

/// Verification Hub — Signature Rewards variant.
/// Shows the Signature Rewards card image.
/// Steps start at "Confirm your identity" (vehicle step removed).

class VerificationHubScreenSignature extends StatelessWidget {
  const VerificationHubScreenSignature({
    super.key,
    this.showBackButton = true,
    this.showStatusBar = true,
    this.showNavBar = true,
    this.showHeroCard = true,
    this.onContinue,
  });

  final bool showBackButton;
  final bool showStatusBar;
  final bool showNavBar;
  final bool showHeroCard;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return KBaseScreenMultiLayout(
      showStatusBar: showStatusBar,
      contentBackgroundColor: AppColors.neutralN50,
      contentPadding: 0,
      appBar: showNavBar
          ? _VerificationNavBar(
              onBack: showBackButton
                  ? () => Navigator.of(context).maybePop()
                  : null,
            )
          : null,
      hasStickyFooter: true,
      footer: AppStickyBottomBar(
        primaryLabel: 'Continue',
        primaryVariant: AppButtonVariant.alternate,
        onPrimary: onContinue ?? () => Navigator.of(context).pop(),
        backgroundColor: AppColors.white,
        showTopDivider: false,
      ),
      content: [
        const SizedBox(height: 4),

        // ── Offer hero card ────────────────────────────────
        if (showHeroCard) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/Signature Rewards.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],

        // ── Steps card ─────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header + blue info box
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your card is almost ready',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.blue50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svgs/count_down_timer.svg',
                              width: 15,
                              height: 15,
                              colorFilter: const ColorFilter.mode(
                                AppColors.navy,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Most applicants get access to their credit card in ~5 minutes.',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.navy,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Column(
                  children: [
                    _StepItem(
                      label: 'Confirm your identity',
                      subtitle: 'Have your ID handy.',
                      state: _StepState.active,
                      showChevron: false,
                    ),
                    _StepItem(
                      label: 'Activate your card',
                      subtitle: 'Review your agreement and activate your card.',
                      hasIncomingLine: true,
                      state: _StepState.pending,
                      isLast: true,
                      showChevron: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

// ── Custom nav bar ─────────────────────────────────────────────────

class _VerificationNavBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _VerificationNavBar({this.onBack});

  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: AppColors.neutralN50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/svgs/logos/logo_orange.svg',
            height: 18,
          ),
          if (onBack != null)
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: onBack,
                child: const Icon(
                  Icons.chevron_left_rounded,
                  size: 28,
                  color: AppColors.navy,
                ),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Need Help?',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.neutralN500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step item ──────────────────────────────────────────────────────

enum _StepState { active, pending }

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.label,
    this.subtitle,
    this.showChevron = false,
    this.state = _StepState.pending,
    this.hasIncomingLine = false,
    this.isLast = false,
  });

  final String label;
  final String? subtitle;
  final bool showChevron;
  final _StepState state;
  final bool hasIncomingLine;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isActive = state == _StepState.active;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 32,
              child: Column(
                children: [
                  SizedBox(
                    height: 18,
                    child: hasIncomingLine
                        ? Center(
                            child: Container(
                              width: 1.5,
                              color: AppColors.neutralN100,
                            ),
                          )
                        : null,
                  ),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? AppColors.white : Colors.transparent,
                      border: Border.all(
                        color: isActive
                            ? AppColors.navy
                            : AppColors.neutralN200,
                        width: isActive ? 2 : 1.5,
                      ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 1.5,
                          color: AppColors.neutralN100,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 13,
                  bottom: isLast ? 17 : 15,
                  left: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.navy,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 13,
                          color: AppColors.neutralN500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
