import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../models/card_offer.dart';
import '../widgets/offer_card_widget.dart';
import 'fpo_application_screen.dart';
import 'compare_offers_screen.dart';

extension _IndexedMap<T> on List<T> {
  Iterable<R> mapIndexed<R>(R Function(int index, T item) f) sync* {
    for (var i = 0; i < length; i++) yield f(i, this[i]);
  }
}

/// Screen 1 — Offers Selection
///
/// Shows all 3 pre-approved offers. User taps a card to select it,
/// then taps "Continue to application" to start the funnel.
/// A confirmation bottom sheet (document checklist) is shown before proceeding.

class OffersSelectionScreen extends StatefulWidget {
  const OffersSelectionScreen({
    super.key,
    this.offers = YendoOffers.all,
  });

  final List<CardOffer> offers;

  @override
  State<OffersSelectionScreen> createState() => _OffersSelectionScreenState();
}

class _OffersSelectionScreenState extends State<OffersSelectionScreen> {
  CardOffer? _selectedOffer;

  @override
  Widget build(BuildContext context) {
    return YendoConfetti.wrap(
      child: KBaseScreenMultiLayout(
        showStatusBar: true,
        contentBackgroundColor: Colors.transparent,
        appBar: const AppNavBar.logo(),
        hasStickyFooter: true,
        footer: AppStickyBottomBar(
          primaryLabel: 'Continue to application',
          onPrimary: _selectedOffer != null ? () => _onContinue(context) : null,
          secondaryLabel: 'Compare offers',
          secondaryVariant: AppButtonVariant.link,
          onSecondary: () => _showCompareSheet(context),
          backgroundColor: AppColors.neutralN50,
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
              textAlign: TextAlign.center,
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

          ...widget.offers.mapIndexed((index, offer) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: OfferCardWidget(
                  offer: offer,
                  isSelected: _selectedOffer?.id == offer.id,
                  onTap: () => setState(() => _selectedOffer = offer),
                  showBulletPoints: true,
                  showRecommended: index == 0,
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
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.navy,
                        ),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => _DocumentReadySheet(
        offer: offer,
        allOffers: widget.offers,
      ),
    );
  }
}

// ── Document Ready Bottom Sheet ────────────────────────────

class _DocumentReadySheet extends StatelessWidget {
  const _DocumentReadySheet({
    required this.offer,
    required this.allOffers,
  });

  final CardOffer offer;
  final List<CardOffer> allOffers;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
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
          // Drag handle
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

          // Icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryO400.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(
              Icons.description_outlined,
              size: 28,
              color: AppColors.primaryO400,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Heading
          Text(
            'Get your documents ready',
            style: AppTextStyles.heading3.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Body
          Text(
            "You'll need to take photos of your car, access to your VIN, and License Plate. You won't be able to select another offer until you're done with the first application. Do you want to continue?",
            style: AppTextStyles.bodyRegular.copyWith(
              color: AppColors.neutralN500,
              height: 1.6,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // CTA
          AppButton(
            label: 'Select offer and continue',
            onPressed: () {
              Navigator.of(context).pop(); // Close sheet
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FpoApplicationScreen(
                    selectedOffer: offer,
                    allOffers: allOffers,
                  ),
                ),
              );
            },
            variant: AppButtonVariant.alternate,
            isFullWidth: true,
          ),

          const SizedBox(height: AppSpacing.md),

          // Cancel
          Center(
            child: AppButton(
              label: 'Go back',
              onPressed: () => Navigator.of(context).pop(),
              variant: AppButtonVariant.link,
            ),
          ),
        ],
      ),
    );
  }
}
