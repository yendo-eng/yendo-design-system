import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../models/card_offer.dart';
import '../widgets/offer_card_widget.dart';
import 'fpo_application_screen.dart';
import 'compare_offers_screen.dart';

/// Auto Refi as Bundle — design exploration.
///
/// Duplicate of Option A with one change: the first card (Express Preferred
/// Rewards) shows a paragraph subtitle explaining the bundled value prop.

class OffersSelectionScreenBundle extends StatefulWidget {
  const OffersSelectionScreenBundle({
    super.key,
    this.offers = YendoOffers.all,
  });

  final List<CardOffer> offers;

  @override
  State<OffersSelectionScreenBundle> createState() =>
      _OffersSelectionScreenBundleState();
}

class _OffersSelectionScreenBundleState
    extends State<OffersSelectionScreenBundle> {
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
                  // Bundle name + subtitle on first card only
                  nameOverride: e.key == 0
                      ? 'Express Preferred Rewards + Auto Refinance'
                      : null,
                  subtitle: e.key == 0
                      ? 'Lorem ipsum for placement only. Get your credit card and save money on your monthly auto payments.'
                      : null,
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
        initialChildSize: 0.55,
        minChildSize: 0.4,
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
                width: 47,
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
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
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
