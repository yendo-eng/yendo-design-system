import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../models/card_offer.dart';
import '../widgets/offer_card_widget.dart';
import '../widgets/tila_table_widget.dart';
import 'compare_offers_screen.dart';
import 'fpo_application_screen.dart';
import 'denial_screen.dart';

/// Downsell screen — used in two scenarios:
///
/// A. [DownsellScreen.vehicleIdRejection] — Yendo rejected the applicant
///    at Vehicle ID. Tone is empathetic — "you still have a path forward."
///
/// B. [DownsellScreen.applicantRejection] — The applicant rejected
///    the Final Offer. Tone is enticing — "before you go, look at these."
///
/// Both show up to 2 remaining offer cards. Tapping a card selects it.
/// The sticky CTA button starts the application funnel for the new offer.

enum DownsellVariant { vehicleIdRejection, applicantRejection }

class DownsellScreen extends StatefulWidget {
  const DownsellScreen({
    super.key,
    required this.variant,
    required this.remainingOffers,
    required this.allOffers,
  }) : assert(remainingOffers.length <= 2,
            'Downsell shows a max of 2 offers');

  /// Named constructor for Vehicle ID rejection by Yendo
  factory DownsellScreen.vehicleIdRejection({
    Key? key,
    required List<CardOffer> remainingOffers,
    required List<CardOffer> allOffers,
  }) =>
      DownsellScreen(
        key: key,
        variant: DownsellVariant.vehicleIdRejection,
        remainingOffers: remainingOffers.take(2).toList(),
        allOffers: allOffers,
      );

  /// Named constructor for applicant rejecting the Final Offer
  factory DownsellScreen.applicantRejection({
    Key? key,
    required List<CardOffer> remainingOffers,
    required List<CardOffer> allOffers,
  }) =>
      DownsellScreen(
        key: key,
        variant: DownsellVariant.applicantRejection,
        remainingOffers: remainingOffers.take(2).toList(),
        allOffers: allOffers,
      );

  final DownsellVariant variant;
  final List<CardOffer> remainingOffers;
  final List<CardOffer> allOffers;

  @override
  State<DownsellScreen> createState() => _DownsellScreenState();
}

class _DownsellScreenState extends State<DownsellScreen> {
  CardOffer? _selectedOffer;

  @override
  void initState() {
    super.initState();
    _selectedOffer = widget.remainingOffers.first;
  }

  bool get _isVehicleRejection =>
      widget.variant == DownsellVariant.vehicleIdRejection;

  @override
  Widget build(BuildContext context) {
    return KBaseScreenMultiLayout(
      showStatusBar: true,
      statusBarBackgroundColor: AppColors.neutralN50,
      contentBackgroundColor: AppColors.neutralN50,
      contentPadding: 0,
      appBar: AppNavBar.logo(backgroundColor: AppColors.neutralN50),
      hasStickyFooter: true,
      footer: AppStickyBottomBar(
        primaryLabel: 'Claim your offer',
        onPrimary: _selectedOffer != null ? () => _onContinue(context) : null,
        secondaryLabel: _isVehicleRejection ? 'Compare credit cards' : 'No thanks',
        secondaryVariant: AppButtonVariant.link,
        onSecondary: _isVehicleRejection
            ? () => _showCompareSheet(context)
            : () => _onDeclineAll(context),
        backgroundColor: AppColors.white,
      ),
      header: null,
      content: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingH,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xs),

              // Section heading — copy varies by variant
              Text(
                _isVehicleRejection
                    ? 'Unfortunately, your vehicle does not qualify but you are still pre-approved.'
                    : "You're still pre-approved for these credit cards",
                style: AppTextStyles.heading3.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // ── Offer cards ─────────────────────────────
              ...widget.remainingOffers.map((offer) => Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppSpacing.md),
                    child: OfferCardWidget(
                      offer: offer,
                      isSelected: _selectedOffer?.id == offer.id,
                      onTap: () =>
                          setState(() => _selectedOffer = offer),
                      showCreditLimit: true,
                      showBulletPoints: false,
                      showApr: true,
                      showAnnualFee: true,
                      showViewTerms: false,
                    ),
                  )),

              // ── View terms / Compare (always active) ─────
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isVehicleRejection) ...[
                      GestureDetector(
                        onTap: () => _showCompareSheet(context),
                        child: Text(
                          'Compare credit cards',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: AppColors.contentDisabled,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.contentDisabled,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '|',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 12,
                            color: AppColors.neutralN200,
                          ),
                        ),
                      ),
                    ],
                    GestureDetector(
                      onTap: () => _showTermsSheet(context),
                      child: Text(
                        'View terms',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w400,
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

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ],
    );
  }

  void _showCompareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutralN200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Compare credit cards', style: AppTextStyles.heading3),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md, 4, AppSpacing.md, AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.xs),
                      CompareOffersScreen.buildComparisonTable(widget.remainingOffers),
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

  void _showTermsSheet(BuildContext context) {
    final offer = _selectedOffer ?? widget.remainingOffers.first;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutralN200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  offer.name,
                  style: AppTextStyles.heading3,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const TilaDisclosureTable(),
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
          allOffers: widget.allOffers,
        ),
      ),
    );
  }

  void _onDeclineAll(BuildContext context) {
    // If user declines all downsell offers → denial screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DenialScreen()),
    );
  }
}

