import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../design_system/components/yendo_confetti.dart';
import '../models/card_offer.dart';
import 'fpo_application_screen.dart';
import '../widgets/offer_card_widget.dart';
import '../widgets/tila_table_widget.dart';

/// Single offer pre-approval — Variant: Cash back / Powered
///
/// Same as Control but replaces APR with cash-back benefit copy.
class OffersSelectionScreenSingleCashback extends StatefulWidget {
  const OffersSelectionScreenSingleCashback({super.key});

  static const offer = YendoOffers.vehicle;

  @override
  State<OffersSelectionScreenSingleCashback> createState() =>
      _OffersSelectionScreenSingleCashbackState();
}

class _OffersSelectionScreenSingleCashbackState
    extends State<OffersSelectionScreenSingleCashback> {
  @override
  Widget build(BuildContext context) {
    return YendoConfetti.wrap(
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
          primaryVariant: AppButtonVariant.primary,
          onPrimary: () => _onContinue(context),
          backgroundColor: AppColors.white,
        ),
        content: [
          const SizedBox(height: 4),

          // ── Header ───────────────────────────────────────────
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

          // ── Single offer card ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingH),
            child: OfferCardWidget(
              offer: OffersSelectionScreenSingleCashback.offer,
              isSelected: false,
              onTap: () {},
              showCreditLimit: true,
              showBulletPoints: false,
              showRecommended: false,
              showApr: false,
              showAnnualFee: false,
              showViewTerms: false,
              showRewardsBullet: true,
              benefitLine: '1.5% cash back*  |  Powered by your car',
              extraBottomPadding: 12.0,
              imageScale: 0.85,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── Footnote ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingH),
            child: Text(
              '*Earn 1.5% cash back with monthly autopay',
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 12,
                color: AppColors.neutralN500,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Terms subheader ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingH),
            child: Text(
              'Terms',
              style: AppTextStyles.bodyRegular.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.navy,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── TILA table inline ─────────────────────────────────────
          const Padding(
            padding:
                EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
            child: TilaDisclosureTable(),
          ),

          const SizedBox(height: AppSpacing.x3l),
        ],
      ),
    );
  }

  void _onContinue(BuildContext context) {
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
                width: 47,
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
              child: const Icon(
                Icons.description_outlined,
                size: 28,
                color: AppColors.primaryO400,
              ),
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
              "You'll need to take photos of your car, access to your VIN, and License Plate. Do you want to continue?",
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
                      selectedOffer: OffersSelectionScreenSingleCashback.offer,
                      allOffers: YendoOffers.all,
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
