import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../models/card_offer.dart';
import 'compare_offers_screen.dart';
import '../widgets/offer_card_widget.dart';

/// Option D — Multiple offers screen variant.
///
/// Differences from Option A:
/// - APR removed from each card
/// - "Compare offers" link moved above the cards
/// - "View terms" removed from inside cards
/// - Footer secondary replaced with "View terms" link that opens
///   a bottom sheet with terms for the selected offer
class OffersSelectionScreenV4 extends StatefulWidget {
  const OffersSelectionScreenV4({
    super.key,
    this.offers = YendoOffers.all,
  });

  final List<CardOffer> offers;

  @override
  State<OffersSelectionScreenV4> createState() =>
      _OffersSelectionScreenV4State();
}

class _OffersSelectionScreenV4State extends State<OffersSelectionScreenV4> {
  CardOffer? _selectedOffer;

  @override
  Widget build(BuildContext context) {
    return YendoConfetti.wrap(
      backgroundColor: AppColors.neutralN50,
      child: KBaseScreenMultiLayout(
        showStatusBar: true,
        contentBackgroundColor: Colors.transparent,
        contentPadding: 0,
        appBar: AppNavBar.logo(
          backgroundColor: Colors.transparent,
          height: 46,
          onBack: () => Navigator.of(context).pop(),
        ),
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

          // ── Offer cards — no APR, no View terms ─────────
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
                  showApr: false,
                  showViewTerms: false,
                ),
              )),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  void _onContinue(BuildContext context) {
    showAppBottomSheet(
      context: context,
      title: 'Get your documents ready',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To complete your application for the ${_selectedOffer!.name}, you\'ll need your government-issued ID and proof of income.',
              style: AppTextStyles.bodyRegular.copyWith(
                color: AppColors.neutralN500,
                height: 1.6,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Continue',
              onPressed: () => Navigator.of(context).pop(),
              isFullWidth: true,
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: AppButton(
                label: 'Go back',
                variant: AppButtonVariant.link,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsSheet(BuildContext context, CardOffer offer) {
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
}
