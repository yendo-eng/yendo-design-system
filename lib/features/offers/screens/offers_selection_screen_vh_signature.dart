import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../design_system/design_system.dart';
import '../models/card_offer.dart';
import 'compare_offers_screen.dart';
import '../widgets/offer_card_widget.dart';
import '../widgets/tila_table_widget.dart';
import 'verification_hub_screen_signature.dart';

/// VH — Signature Rewards variant
///
/// Pre-approval offer selection screen whose CTA opens the
/// Verification Hub (Signature Rewards) in a full-height bottom sheet.
class OffersSelectionScreenVHSignature extends StatefulWidget {
  const OffersSelectionScreenVHSignature({
    super.key,
    this.offers = YendoOffers.all,
  });

  final List<CardOffer> offers;

  @override
  State<OffersSelectionScreenVHSignature> createState() =>
      _OffersSelectionScreenVHSignatureState();
}

class _OffersSelectionScreenVHSignatureState
    extends State<OffersSelectionScreenVHSignature> {
  CardOffer? _selectedOffer;

  @override
  void initState() {
    super.initState();
    _selectedOffer = widget.offers.first;
  }

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
          primaryLabel: 'Claim your offer',
          onPrimary:
              _selectedOffer != null ? () => _onContinue(context) : null,
          secondaryLabel: 'Compare credit cards',
          secondaryVariant: AppButtonVariant.link,
          onSecondary: () => _showCompareSheet(context),
          backgroundColor: AppColors.white,
        ),
        content: [
          const SizedBox(height: 8),

          Center(
            child: Text(
              "You're pre-approved!",
              style: AppTextStyles.heading3.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Offer cards ─────────────────────────────────────────────────
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
                  showApr: true,
                  showAnnualFee: true,
                  showViewTerms: false,
                  extraBottomPadding: 10.0,
                  imageScale: 0.85,
                ),
              )),

          // ── View terms ───────────────────────────────────────────────────
          Center(
            child: GestureDetector(
              onTap: () => _showTermsSheet(
                context,
                _selectedOffer ?? widget.offers.first,
              ),
              child: Text(
                'View terms',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.neutralN500,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.neutralN500,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Opens the Verification Hub (Signature Rewards) in a full-height bottom sheet.
  void _onContinue(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.95,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            color: AppColors.neutralN50,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Header row with title + close button
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH, 20,
                    AppSpacing.screenPaddingH, 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Welcome, Ringo!',
                        style: AppTextStyles.heading3.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: SvgPicture.asset(
                          'assets/svgs/close_icon_no_bg.svg',
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: VerificationHubScreenSignature(
                      showBackButton: false,
                      showStatusBar: false,
                      showNavBar: false,
                      onContinue: () {
                        Navigator.of(context).pop(); // close sheet
                        Navigator.of(context).pop(); // back to FPO
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTermsSheet(BuildContext context, CardOffer offer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 68,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutralN200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Yendo Mastercard® Credit Card',
                    style: AppTextStyles.heading3.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Interest Rates and Interest Charges',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                      color: AppColors.neutralN500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  child: const TilaDisclosureTable(),
                ),
              ),
            ],
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
                width: 68,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutralN200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Compare credit cards',
                    style: AppTextStyles.heading3.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md, 4, AppSpacing.md, AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.xs),
                      CompareOffersScreen.buildComparisonTable(widget.offers),
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
