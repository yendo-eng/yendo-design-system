import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../design_system/design_system.dart';
import '../models/card_offer.dart';
import 'fpo_application_screen.dart';
import 'compare_offers_screen.dart';
import '../widgets/offer_card_widget.dart';

/// Option 2 — Alternative visual design for the multiple offers screen.
///
/// Same information and selection logic as Option A.
/// The credit limit is the visual hero: large bold number at the top of each
/// card, with the card SVG image fully contained and clipped inside the
/// card's padded area (following the denial-screen layout pattern).

class OffersSelectionScreenV2 extends StatefulWidget {
  const OffersSelectionScreenV2({
    super.key,
    this.offers = YendoOffers.all,
  });

  final List<CardOffer> offers;

  @override
  State<OffersSelectionScreenV2> createState() =>
      _OffersSelectionScreenV2State();
}

class _OffersSelectionScreenV2State extends State<OffersSelectionScreenV2> {
  CardOffer? _selectedOffer;

  @override
  Widget build(BuildContext context) {
    return YendoConfetti.wrap(
      backgroundColor: AppColors.white,
      child: KBaseScreenMultiLayout(
        showStatusBar: true,
        statusBarBackgroundColor: AppColors.white,
        contentPadding: 0,
        contentBackgroundColor: Colors.transparent, // confetti shows through
        appBar: AppNavBar.logo(backgroundColor: AppColors.white, height: 46),
        hasStickyFooter: true,
        footer: AppStickyBottomBar(
          primaryLabel: 'Continue to application',
          onPrimary:
              _selectedOffer != null ? () => _onContinue(context) : null,
          secondaryLabel: 'Compare offers',
          secondaryVariant: AppButtonVariant.link,
          onSecondary: () => _showCompareSheet(context),
          backgroundColor: AppColors.neutralN50,
        ),
        content: [
          const SizedBox(height: AppSpacing.sm),

          // Header — same copy as Option A
          Center(
            child: Text(
              'Congratulations!',
              style: AppTextStyles.bodyRegular.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.neutralN500,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xxs),

          Center(
            child: Text(
              'You have ${widget.offers.length == 1 ? 'an offer' : 'three offers'}',
              style: AppTextStyles.heading3.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Gray section starts here — cards sit on neutralN50 ──
          Container(
            color: AppColors.neutralN50,
            width: double.infinity,
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Column(
              children: [
                ...widget.offers.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenPaddingH,
                        0,
                        AppSpacing.screenPaddingH,
                        AppSpacing.md,
                      ),
                      child: _BigNumberOfferCard(
                        offer: e.value,
                        isSelected: _selectedOffer?.id == e.value.id,
                        onTap: () => setState(() => _selectedOffer = e.value),
                        showRecommended: e.key == 0,
                        onViewTerms: () => _showTerms(context, e.value),
                      ),
                    )),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  void _showTerms(BuildContext context, CardOffer offer) {
    showAppBottomSheet(
      context: context,
      title: offer.name,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Text(
          offer.terms,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.neutralN500,
            height: 1.6,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void _showCompareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutralN200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Text(
                      'Compare your credit card offers',
                      style: AppTextStyles.heading3.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.neutralN100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            size: 18, color: AppColors.navy),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1, color: AppColors.neutralN100),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.xs),
                      CompareOffersScreen.buildComparisonTable(widget.offers),
                      const SizedBox(height: AppSpacing.lg),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onContinue(BuildContext context) {
    if (_selectedOffer == null) return;
    _showDocumentReadySheet(context, _selectedOffer!);
  }

  void _showDocumentReadySheet(BuildContext context, CardOffer offer) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenPaddingH,
          AppSpacing.lg,
          AppSpacing.screenPaddingH,
          bottomPadding > 0 ? bottomPadding + AppSpacing.xs : AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutralN200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primaryO400.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: const Icon(Icons.description_outlined,
                  size: 28, color: AppColors.primaryO400),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Get your documents ready',
              style: AppTextStyles.heading3.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              "You'll need to take photos of your car, access to your VIN, and License Plate. You won't be able to select another offer until you're done with the first application. Do you want to continue?",
              style: AppTextStyles.bodyRegular.copyWith(
                color: AppColors.neutralN500,
                height: 1.6,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Select offer and continue',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FpoApplicationScreen(
                      selectedOffer: offer,
                      allOffers: widget.offers,
                    ),
                  ),
                );
              },
              variant: AppButtonVariant.alternate,
              isFullWidth: true,
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: AppButton(
                label: 'Go back',
                onPressed: () => Navigator.of(context).pop(),
                variant: AppButtonVariant.link,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Option A — Rejection-style with 3 offers
// ─────────────────────────────────────────────────────────────────────────────

/// Option A — "You may still qualify" screen.
///
/// Uses the rejection/downsell tone and visual style but surfaces all three
/// pre-approved offers instead of only the 2 remaining after a rejection.
/// Uses the same [_BigNumberOfferCard] layout as V2.

class OffersSelectionScreenV3 extends StatefulWidget {
  const OffersSelectionScreenV3({
    super.key,
    this.offers = YendoOffers.all,
  });

  final List<CardOffer> offers;

  @override
  State<OffersSelectionScreenV3> createState() =>
      _OffersSelectionScreenV3State();
}

class _OffersSelectionScreenV3State extends State<OffersSelectionScreenV3> {
  CardOffer? _selectedOffer;

  @override
  Widget build(BuildContext context) {
    return YendoConfetti.wrap(
      backgroundColor: AppColors.neutralN50,
      child: KBaseScreenMultiLayout(
        showStatusBar: true,
        contentBackgroundColor: Colors.transparent,
        contentPadding: 0,
        appBar: AppNavBar.logo(backgroundColor: Colors.transparent, height: 46),
        hasStickyFooter: true,
        footer: AppStickyBottomBar(
          primaryLabel: 'Continue to application',
          onPrimary:
              _selectedOffer != null ? () => _onContinue(context) : null,
          secondaryLabel: 'Compare offers',
          secondaryVariant: AppButtonVariant.link,
          onSecondary: () => _showCompareSheet(context),
          backgroundColor: AppColors.white,
        ),
        content: [
          const SizedBox(height: AppSpacing.md),

          Center(
            child: Text(
              'Congratulations!',
              style: AppTextStyles.bodyRegular.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.neutralN500,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xxs),

          Center(
            child: Text(
              'You have ${widget.offers.length == 1 ? 'an offer' : 'three offers'}',
              style: AppTextStyles.heading3.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          ...widget.offers.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPaddingH,
                  0,
                  AppSpacing.screenPaddingH,
                  AppSpacing.md,
                ),
                child: OfferCardWidget(
                  offer: e.value,
                  isSelected: _selectedOffer?.id == e.value.id,
                  onTap: () => setState(() => _selectedOffer = e.value),
                  showCreditLimit: true,
                  showBulletPoints: false,
                  showRecommended: e.key == 0,
                ),
              )),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  void _showCompareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutralN200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Text(
                      'Compare your credit card offers',
                      style: AppTextStyles.heading3.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.neutralN100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            size: 18, color: AppColors.navy),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1, color: AppColors.neutralN100),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.xs),
                      CompareOffersScreen.buildComparisonTable(
                          widget.offers),
                      const SizedBox(height: AppSpacing.lg),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onContinue(BuildContext context) {
    if (_selectedOffer == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FpoApplicationScreen(
          selectedOffer: _selectedOffer!,
          allOffers: widget.offers,
        ),
      ),
    );
  }
}

// ── Big Number Offer Card ──────────────────────────────────────────────────
//
// Layout (all content inside card padding — nothing touches the edges):
//
//  ┌──────────────────────────────────────────┐
//  │ Name                          [badge/✓]  │
//  │                                          │
//  │  ┌──────────── ClipRRect ─────────────┐  │  ← image fully inside padding
//  │  │         [card SVG image]           │  │
//  │  └────────────────────────────────────┘  │
//  │                                          │
//  │ $10,000                                  │  ← big bold hero number
//  │ Pre-approved credit limit                │
//  │                                          │
//  │ [APR pill] [Cash pill] [Rewards pill]    │
//  │ View terms                               │
//  └──────────────────────────────────────────┘

class _BigNumberOfferCard extends StatelessWidget {
  const _BigNumberOfferCard({
    required this.offer,
    required this.isSelected,
    required this.onTap,
    required this.onViewTerms,
    this.showRecommended = false,
  });

  final CardOffer offer;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onViewTerms;
  final bool showRecommended;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.neutralN500 : AppColors.neutralN100,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.neutralN500.withValues(alpha: 0.18),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
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
            // ── Recommended pill — centered above the card image ──────
            if (showRecommended) ...[
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryO400,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  child: const Text(
                    'Recommended',
                    style: TextStyle(
                      fontFamily: 'PPNeueMontreal',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
            ],

            // ── Card name — centered, dark, above the image ──────────
            Center(
              child: Text(
                offer.name,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.navy,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // ── Card image — centered, 30% smaller, checkmark overlay ─
            Center(
              child: SizedBox(
                width: 126,
                height: 77,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      offer.imagePath,
                      width: 126,
                      height: 77,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // ── Credit limit — centered ───────────────────────────────
            Center(
              child: Text(
                offer.creditLimit,
                style: AppTextStyles.spaceGrotesk(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            Center(
              child: Text(
                'Pre-approved credit limit',
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 12,
                  color: AppColors.neutralN500,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // ── Bullet points (no pre-approved — shown via credit limit) ─
            ...[
              'Cash advance limit ${offer.cashAdvanceLimit}',
              'APR ${offer.apr}',
              offer.rewardsLine,
            ].map((point) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.neutralN500),
                      ),
                      Expanded(
                        child: Text(
                          point,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.neutralN500),
                        ),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: AppSpacing.sm),

            // ── View terms ────────────────────────────────────────────
            GestureDetector(
              onTap: onViewTerms,
              child: Text(
                'View terms',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: AppColors.contentDisabled,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.contentDisabled,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

