import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../design_system/design_system.dart';
import '../models/card_offer.dart';

/// Verification Hub — high-fidelity application progress screen.
/// Always shows the Express Preferred Rewards / $10,000 offer.

class VerificationHubScreen extends StatelessWidget {
  const VerificationHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const offer = YendoOffers.vehicle;
    return KBaseScreenMultiLayout(
      showStatusBar: true,
      contentBackgroundColor: AppColors.neutralN50,
      contentPadding: 0,
      appBar: _VerificationNavBar(
        onBack: () => Navigator.of(context).maybePop(),
      ),
      hasStickyFooter: true,
      footer: AppStickyBottomBar(
        primaryLabel: 'Continue to asset details',
        primaryVariant: AppButtonVariant.alternate,
        onPrimary: () {},
        backgroundColor: AppColors.white,
        showTopDivider: false,
        topPadding: 28,
      ),
      content: [
        const SizedBox(height: 4),

        // ── Welcome header ─────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Text(
            'Welcome, John!',
            style: AppTextStyles.heading3.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ── Offer hero card ────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: _OfferHeroCard(offer: offer),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Steps header ───────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Row(
            children: [
              Text(
                'Get your card in 3 steps',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.neutralN500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.neutralN200),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '7 minutes',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.neutralN500,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // ── Steps list ─────────────────────────────────────
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
            child: const Column(
              children: [
                _StepItem(
                  label: 'Asset details',
                  subtitle:
                      'Make sure you have your vehicle details, VIN, and license plate',
                  state: _StepState.active,
                  showChevron: false,
                ),
                _StepItem(
                  label: 'Personal information',
                  subtitle: 'Have your ID handy',
                  hasIncomingLine: true,
                  state: _StepState.pending,
                  showChevron: false,
                ),
                _StepItem(
                  label: 'Activate your card',
                  hasIncomingLine: true,
                  state: _StepState.pending,
                  isLast: true,
                  showChevron: false,
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
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFC7B40),
            Color(0xFFFA652C),
            Color(0xFFD94410),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Subtle decorative circles
          Positioned(
            top: -40, right: -30,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -50, right: 40,
            child: Container(
              width: 130, height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          // Mastercard — bottom right
          Positioned(
            bottom: 18, right: 20,
            child: SvgPicture.asset(
              'assets/svgs/logos/mastercard.svg',
              width: 38,
            ),
          ),

          // Card content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Yendo white logo top-left
                SvgPicture.asset(
                  'assets/svgs/logos/new_logo.svg',
                  height: 13,
                ),

                const SizedBox(height: 10),

                // Card name
                Text(
                  offer.name,
                  style: const TextStyle(
                    fontFamily: 'PPNeueMontreal',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 18),

                // "PRE-APPROVED FOR UP TO" label
                Text(
                  'PRE-APPROVED FOR UP TO',
                  style: TextStyle(
                    fontFamily: 'PPNeueMontreal',
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),

                const SizedBox(height: 2),

                // Credit limit — Space Grotesk, matched to other cards
                Text(
                  offer.creditLimit,
                  style: AppTextStyles.spaceGrotesk(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ).copyWith(color: Colors.white, height: 1.1),
                ),

                const SizedBox(height: 10),

                // APR
                Row(
                  children: [
                    Text(
                      'APR',
                      style: TextStyle(
                        fontFamily: 'PPNeueMontreal',
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      offer.apr,
                      style: const TextStyle(
                        fontFamily: 'PPNeueMontreal',
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
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
                            style: AppTextStyles.bodyRegular.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: isActive
                                  ? AppColors.navy
                                  : AppColors.neutralN500,
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
