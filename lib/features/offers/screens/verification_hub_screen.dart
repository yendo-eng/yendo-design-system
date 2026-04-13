import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../design_system/design_system.dart';
import '../models/card_offer.dart';

/// Verification Hub — high-fidelity application progress screen.
/// Always shows the Express Preferred Rewards / $10,000 offer.

class VerificationHubScreen extends StatelessWidget {
  const VerificationHubScreen({
    super.key,
    this.showBackButton = true,
    this.showStatusBar = true,
    this.showNavBar = true,
    this.showHeroCard = true,
    this.onContinue,
  });

  /// Set to false when displayed inside a bottom sheet (back arrow not needed).
  final bool showBackButton;

  /// Set to false when displayed inside a bottom sheet (status bar not needed).
  final bool showStatusBar;

  /// Set to false when displayed inside a bottom sheet (logo + help not needed).
  final bool showNavBar;

  /// Set to false to hide the Platinum Rewards hero card image at the top.
  final bool showHeroCard;

  /// Override the CTA action. Defaults to Navigator.pop when null.
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    const offer = YendoOffers.vehicle;
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
            child: _OfferHeroCard(offer: offer),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],

        // ── Steps card (header + list) ─────────────────────
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
                // Header + pill inside the card
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
                                'Most applicants get access to their credit card in ~7 minutes.',
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
                  label: 'Verify your vehicle',
                  subtitle: 'You may be asked for license plate, VIN, and/or photos.',
                  state: _StepState.active,
                  showChevron: false,
                ),
                _StepItem(
                  label: 'Confirm your identity',
                  subtitle: 'Have your ID handy.',
                  hasIncomingLine: true,
                  state: _StepState.pending,
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
          // Logo — always truly centered
          SvgPicture.asset(
            'assets/svgs/logos/logo_orange.svg',
            height: 18,
          ),
          // Left — bare chevron (no circle)
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
          // Right — Need Help?
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

// ── Offer hero card ────────────────────────────────────────────────

class _OfferHeroCard extends StatelessWidget {
  const _OfferHeroCard({required this.offer});

  final CardOffer offer;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SvgPicture.asset(
        'assets/images/Yendo Vehicle Equity Mastercard.svg',
        fit: BoxFit.cover,
        width: double.infinity,
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

  /// True for items 2+ — extends the connector line through the top padding
  /// so the line reaches from the previous circle to this one seamlessly.
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
            // ── Circle + connectors ──────────────────────
            SizedBox(
              width: 32,
              child: Column(
                children: [
                  // Top gap — draws incoming line if not the first item
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

                  // Circle indicator
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isActive ? AppColors.white : Colors.transparent,
                      border: Border.all(
                        color: isActive
                            ? AppColors.navy
                            : AppColors.neutralN200,
                        width: isActive ? 2 : 1.5,
                      ),
                    ),
                    child: null,
                  ),

                  // Outgoing connector line to next item
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

            // ── Text content ─────────────────────────────
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 13,
                  bottom: isLast ? 17 : 15,
                  left: 4,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
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
                    if (showChevron) ...[
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: AppColors.neutralN500
                              .withValues(alpha: 0.6),
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
