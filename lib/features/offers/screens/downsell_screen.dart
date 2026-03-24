import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../models/card_offer.dart';
import '../widgets/offer_card_widget.dart';
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

  bool get _isVehicleRejection =>
      widget.variant == DownsellVariant.vehicleIdRejection;

  @override
  Widget build(BuildContext context) {
    return KBaseScreenMultiLayout(
      showStatusBar: true,
      statusBarBackgroundColor: AppColors.white,
      contentBackgroundColor: AppColors.neutralN50,
      contentPadding: 0,
      appBar: AppNavBar.logo(backgroundColor: AppColors.white),
      hasStickyFooter: true,
      footer: AppStickyBottomBar(
        primaryLabel: 'Continue to application',
        onPrimary: _selectedOffer != null ? () => _onContinue(context) : null,
        secondaryLabel: 'No thanks',
        secondaryVariant: AppButtonVariant.link,
        onSecondary: () => _onDeclineAll(context),
        backgroundColor: AppColors.neutralN50,
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
              const SizedBox(height: AppSpacing.md),

              // Section heading — copy varies by variant
              Text(
                _isVehicleRejection
                    ? 'You may still qualify'
                    : 'Looking for another option?',
                style: AppTextStyles.heading3.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: AppSpacing.xs),

              // Subtext
              Text(
                _isVehicleRejection
                    ? 'We weren\'t able to approve your application but these other offers may be a better match. Check your eligibility in minutes.'
                    : 'Before you go, take a look at these other cards — one of them might be the right fit.',
                style: AppTextStyles.bodyRegular.copyWith(
                  fontSize: 14,
                  color: AppColors.neutralN500,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

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
                    ),
                  )),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ],
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

