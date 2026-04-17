import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../design_system/design_system.dart';
import '../models/card_offer.dart';

/// Auto Refi v2 Final Offer — Variation A: Card-First
///
/// Based on wireframe: https://www.figma.com/design/HE3XtqUXb42FXcxsxdnBp7/Auto-refi-V2?node-id=10728-7096
///
/// Layout:
///   • Yendo logo nav
///   • Title "Accept your Platinum Rewards Mastercard"
///   • Full-width card image inside a contained section
///   • Credit card benefits & details (bullet list)
///   • Refinance details (monthly payment hero + savings badge + info link)
///   • Expiry notice
///   • "Accept my offer" primary CTA + "I don't want this offer" link
///
/// Low-fidelity prototype — no state management, UI-only.

class AutoRefiFinalOfferV2A extends StatelessWidget {
  const AutoRefiFinalOfferV2A({
    super.key,
    this.offer = YendoOffers.vehicle,
    this.monthlyPayment = r'$232.14',
    this.monthlySavings = r'$100',
    this.offerExpiry = 'August 22, 2025 at 11:59pm CT',
    this.onAccept,
    this.onDecline,
    this.onLearnMore,
  });

  final CardOffer offer;
  final String monthlyPayment;
  final String monthlySavings;
  final String offerExpiry;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onLearnMore;

  @override
  Widget build(BuildContext context) {
    return KBaseScreenMultiLayout(
      showStatusBar: true,
      statusBarBackgroundColor: AppColors.white,
      contentBackgroundColor: AppColors.white,
      contentPadding: 0,
      appBar: AppNavBar.logo(backgroundColor: AppColors.white, height: 46),
      hasStickyFooter: true,
      footer: _Footer(onAccept: onAccept, onDecline: onDecline, offerExpiry: offerExpiry),
      content: [
        // ── Title ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPaddingH, AppSpacing.md,
            AppSpacing.screenPaddingH, AppSpacing.lg,
          ),
          child: Text(
            'Accept your ${offer.name} Mastercard',
            style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
          ),
        ),

        // ── Card section ───────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.neutralN50,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full-width card image
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  child: SvgPicture.asset(
                    offer.imagePath,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // "Credit card benefits and details"
                Text(
                  'Credit card benefits and details',
                  style: AppTextStyles.body2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: AppSpacing.xs),

                _BulletItem('APR: ${offer.apr}'),
                _BulletItem('Automatic credit limit increases every month*'),
                _BulletItem('Instant access to funds'),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // ── Refinance details ──────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Refinance details',
                style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: AppSpacing.md),

              Text(
                'Loan monthly payment',
                style: AppTextStyles.body2.copyWith(color: AppColors.neutralN500),
              ),

              const SizedBox(height: AppSpacing.xxs),

              // Big monthly payment number
              RichText(
                text: TextSpan(
                  style: AppTextStyles.spaceGrotesk(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                  children: [
                    TextSpan(text: monthlyPayment),
                    TextSpan(
                      text: '/mo',
                      style: AppTextStyles.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.neutralN500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Savings badge + info icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.green400.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    ),
                    child: Text(
                      'Save \$$monthlySavings monthly',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.green400,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(Icons.info_outline, size: 18, color: AppColors.contentDisabled),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Learn more link
              GestureDetector(
                onTap: onLearnMore,
                child: Text(
                  'Learn more about your 1-click refinance',
                  style: AppTextStyles.link,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}

// ── Variation B: Approval-First Compact ───────────────────────────────────────

/// Auto Refi v2 Final Offer — Variation B: Approval-First
///
/// Based on wireframe: https://www.figma.com/design/HE3XtqUXb42FXcxsxdnBp7/Auto-refi-V2?node-id=10728-7861
///
/// Layout:
///   • "You're approved!" centered heading
///   • White card: offer name left + small card image right
///   • Full benefit bullet list (5 items)
///   • "Learn more about 1-click refinance" link
///   • Credit limit footnote
///   • Expiry notice
///   • "Accept my offer" primary CTA + "I don't want this offer" link
///
/// Low-fidelity prototype — no state management, UI-only.

class AutoRefiFinalOfferV2B extends StatelessWidget {
  const AutoRefiFinalOfferV2B({
    super.key,
    this.offer = YendoOffers.vehicle,
    this.offerExpiry = 'August 22, 2025 at 11:59pm CT',
    this.onAccept,
    this.onDecline,
    this.onLearnMore,
  });

  final CardOffer offer;
  final String offerExpiry;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onLearnMore;

  @override
  Widget build(BuildContext context) {
    return KBaseScreenMultiLayout(
      showStatusBar: true,
      statusBarBackgroundColor: AppColors.white,
      contentBackgroundColor: AppColors.white,
      contentPadding: 0,
      hasStickyFooter: true,
      footer: _Footer(onAccept: onAccept, onDecline: onDecline, offerExpiry: offerExpiry),
      content: [
        const SizedBox(height: AppSpacing.lg),

        // ── "You're approved!" heading ─────────────────────
        Center(
          child: Text(
            "You're approved!",
            style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ── Offer card ─────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.neutralN100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card name + small card image
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        offer.name,
                        style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      child: SvgPicture.asset(
                        offer.imagePath,
                        width: 80,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  'Benefits and details',
                  style: AppTextStyles.body2.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.navy,
                  ),
                ),

                const SizedBox(height: AppSpacing.xs),

                _BulletItem('Automatic credit limit increases every month*'),
                _BulletItem('Instant access to funds'),
                _BulletItem('1-click refinance'),
                _BulletItem('No penalty for early pay-off'),
                _BulletItem('APR: ${offer.apr}'),

                const SizedBox(height: AppSpacing.sm),

                // Learn more link
                GestureDetector(
                  onTap: onLearnMore,
                  child: Text(
                    'Learn more about 1-click refinance',
                    style: AppTextStyles.link,
                  ),
                ),
              ],
            ),
          ),
        ),

        const Spacer(),

        // ── Footnote ───────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Text(
            '*Your credit limit increases each month as you pay down your auto loan.',
            style: AppTextStyles.caption.copyWith(color: AppColors.neutralN500),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

// ── Variation C: Hybrid — Card Hero + Combined Details ────────────────────────

/// Auto Refi v2 Final Offer — Variation C: Hybrid
///
/// Combines wireframe 1's full-width card hero with wireframe 2's
/// compact benefit list. Emphasizes both the credit card and refi savings
/// in a single scrollable card below.
///
/// Low-fidelity prototype — no state management, UI-only.

class AutoRefiFinalOfferV2C extends StatelessWidget {
  const AutoRefiFinalOfferV2C({
    super.key,
    this.offer = YendoOffers.vehicle,
    this.monthlyPayment = r'$232.14',
    this.monthlySavings = r'$100',
    this.offerExpiry = 'August 22, 2025 at 11:59pm CT',
    this.onAccept,
    this.onDecline,
    this.onLearnMore,
  });

  final CardOffer offer;
  final String monthlyPayment;
  final String monthlySavings;
  final String offerExpiry;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onLearnMore;

  @override
  Widget build(BuildContext context) {
    return KBaseScreenMultiLayout(
      showStatusBar: true,
      statusBarBackgroundColor: AppColors.white,
      contentBackgroundColor: AppColors.white,
      contentPadding: 0,
      appBar: AppNavBar.logo(backgroundColor: AppColors.white, height: 46),
      hasStickyFooter: true,
      footer: _Footer(onAccept: onAccept, onDecline: onDecline, offerExpiry: offerExpiry),
      content: [
        const SizedBox(height: AppSpacing.sm),

        // ── "You're approved!" ─────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You're approved for",
                style: AppTextStyles.body2.copyWith(color: AppColors.neutralN500),
              ),
              Text(
                '${offer.name} Mastercard',
                style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ── Full-width card image ──────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: SvgPicture.asset(
              offer.imagePath,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Combined details card ──────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.neutralN100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Credit card section
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Credit card',
                        style: AppTextStyles.overline.copyWith(
                          letterSpacing: 1.2,
                          color: AppColors.neutralN600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        offer.creditLimit,
                        style: AppTextStyles.spaceGrotesk(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      Text(
                        'Credit limit  •  APR ${offer.apr}',
                        style: AppTextStyles.body2.copyWith(color: AppColors.neutralN500),
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, color: AppColors.neutralN100),

                // Auto loan section
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auto loan refinance',
                        style: AppTextStyles.overline.copyWith(
                          letterSpacing: 1.2,
                          color: AppColors.neutralN600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      RichText(
                        text: TextSpan(
                          style: AppTextStyles.spaceGrotesk(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                          children: [
                            TextSpan(text: monthlyPayment),
                            TextSpan(
                              text: '/mo',
                              style: AppTextStyles.spaceGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.neutralN500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.green400.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                        ),
                        child: Text(
                          'Save \$$monthlySavings/mo',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.green400,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, color: AppColors.neutralN100),

                // Benefits list
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What's included",
                        style: AppTextStyles.body2.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      _BulletItem('Credit limit increases every month'),
                      _BulletItem('Instant access to funds'),
                      _BulletItem('1-click refinance — no paperwork'),
                      _BulletItem('No penalty for early pay-off'),
                      const SizedBox(height: AppSpacing.xs),
                      GestureDetector(
                        onTap: onLearnMore,
                        child: Text(
                          'Learn more about 1-click refinance',
                          style: AppTextStyles.link,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}

// ── Shared widgets ─────────────────────────────────────────────────────────────

class _BulletItem extends StatelessWidget {
  const _BulletItem(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: AppTextStyles.body2.copyWith(color: AppColors.neutralN500),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body2.copyWith(color: AppColors.neutralN500),
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.offerExpiry,
    this.onAccept,
    this.onDecline,
  });

  final String offerExpiry;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPaddingH,
        AppSpacing.md,
        AppSpacing.screenPaddingH,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Expiry notice
          Text(
            'This offer expires on $offerExpiry',
            style: AppTextStyles.caption.copyWith(color: AppColors.neutralN500),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.md),

          // Primary CTA
          AppButton(
            label: 'Accept my offer',
            onPressed: onAccept ?? () {},
            variant: AppButtonVariant.primary,
            isFullWidth: true,
          ),

          const SizedBox(height: AppSpacing.sm),

          // Decline link
          AppButton(
            label: "I don't want this offer",
            onPressed: onDecline ?? () {},
            variant: AppButtonVariant.link,
          ),
        ],
      ),
    );
  }
}
