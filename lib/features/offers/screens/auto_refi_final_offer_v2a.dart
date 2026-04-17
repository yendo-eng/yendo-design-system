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

        const SizedBox(height: AppSpacing.lg),

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

// ── Variation D: Credit-Card Hero — emphasise card, bundle refi ───────────────

/// Auto Refi v2 Final Offer — Variation D: Credit-Card Hero
///
/// Messaging strategy:
///   • Lead with the credit card — this is the exciting part.
///   • Reframe the auto refinance as a simple, automatic bundle ("one tap").
///   • Allay refi anxiety with card benefits: instant cash + growing limit.
///   • Show APR transparently (29.99%).
///
/// Mid-fidelity prototype — uses real tokens, icon placeholders, full layout.

class AutoRefiFinalOfferV2D extends StatelessWidget {
  const AutoRefiFinalOfferV2D({
    super.key,
    this.offer = YendoOffers.vehicle,
    this.monthlyPayment = r'$232.14',
    this.monthlySavings = r'$100',
    this.offerExpiry = 'August 22, 2025 at 11:59pm CT',
    this.onAccept,
    this.onDecline,
  });

  final CardOffer offer;
  final String monthlyPayment;
  final String monthlySavings;
  final String offerExpiry;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

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
        // ── Approved badge + heading ───────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPaddingH, AppSpacing.md,
            AppSpacing.screenPaddingH, 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "You're approved" pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.green400.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 14, color: AppColors.green400),
                    const SizedBox(width: 4),
                    Text(
                      "You're approved",
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.green400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              Text(
                'Accept your\n${offer.name} Mastercard',
                style: AppTextStyles.h2.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),

              const SizedBox(height: AppSpacing.xs),

              Text(
                'Get instant access to a revolving credit line — '
                'your limit grows every month.',
                style: AppTextStyles.body2.copyWith(color: AppColors.neutralN500),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ── Card hero ──────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: SvgPicture.asset(
              offer.imagePath,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Card benefits ──────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.neutralN50,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CARD BENEFITS',
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.neutralN500,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                _BenefitRow(
                  icon: Icons.bolt_rounded,
                  iconColor: AppColors.primaryO400,
                  title: 'Instant access to cash',
                  subtitle: 'Use your credit line the moment your card arrives.',
                ),

                const SizedBox(height: AppSpacing.sm),

                _BenefitRow(
                  icon: Icons.trending_up_rounded,
                  iconColor: AppColors.primaryO400,
                  title: 'Credit limit grows every month',
                  subtitle:
                      'Your limit automatically increases as you pay down your loan.',
                ),

                const SizedBox(height: AppSpacing.sm),

                _BenefitRow(
                  icon: Icons.percent_rounded,
                  iconColor: AppColors.neutralN500,
                  title: 'APR 29.99%',
                  subtitle: 'Standard variable APR.',
                  titleColor: AppColors.neutralN600,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ── Refinance bundle — kept secondary / reassuring ─
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.neutralN100),
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.navy.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.directions_car_rounded,
                          size: 16, color: AppColors.navy),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Includes auto refinance',
                          style: AppTextStyles.bodyRegular.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Bundled with your card — one tap, no paperwork',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.neutralN500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Monthly payment row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      monthlyPayment,
                      style: AppTextStyles.spaceGrotesk(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        '/mo',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.neutralN500,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

                const SizedBox(height: AppSpacing.xs),

                // Reassurance text
                Row(
                  children: [
                    const Icon(Icons.lock_outline_rounded,
                        size: 13, color: AppColors.contentDisabled),
                    const SizedBox(width: 4),
                    Text(
                      'No penalty for early pay-off · Takes 10 seconds',
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.contentDisabled),
                    ),
                  ],
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

// ── Benefit row widget (used by Variation D) ───────────────────────────────────

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.titleColor,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyRegular.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: titleColor ?? AppColors.navy,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.neutralN500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
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
