import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../models/card_offer.dart';
import 'compare_offers_screen.dart';
import 'fpo_application_screen.dart';
import '../widgets/offer_card_widget.dart';

/// Option D — Multiple offers screen variant.
///
/// Differences from Option A:
/// - APR removed from each card
/// - "Compare offers" link moved to the sticky footer
/// - "View terms" removed from inside cards; centered link below cards
/// - Card image shrunk 15%; cards slightly taller
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

          // ── Offer cards — taller, smaller image, no APR, no View terms ──
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
                  extraBottomPadding: 12.0,
                  imageScale: 0.85,
                ),
              )),

          // ── Centered "View terms" link below cards ───────
          Center(
            child: GestureDetector(
              onTap: _selectedOffer != null
                  ? () => _showTermsSheet(context, _selectedOffer!)
                  : null,
              child: Text(
                'View terms',
                style: AppTextStyles.bodySmall.copyWith(
                  color: _selectedOffer != null
                      ? AppColors.neutralN500
                      : AppColors.contentDisabled,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: _selectedOffer != null
                      ? AppColors.neutralN500
                      : AppColors.contentDisabled,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  void _onContinue(BuildContext context) {
    final offer = _selectedOffer!;
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
            // Drag handle
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

  void _showTermsSheet(BuildContext context, CardOffer offer) {
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
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
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
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Yendo Mastercard® Credit Card',
                        style: AppTextStyles.heading3.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
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
                  child: const _TilaTable(),
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
                      'Compare credit cards',
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

// ─────────────────────────────────────────────────────────────────────────────
// TILA Disclosure Table
// ─────────────────────────────────────────────────────────────────────────────

class _TilaTable extends StatelessWidget {
  const _TilaTable();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Interest Rates and Interest Charges'),
        _tilaRow(
          'Annual Percentage Rate (APR) for Purchases',
          '24.88% to 35.88%,* when you open your account, based on creditworthiness.',
          valueBold: true,
        ),
        _tilaRow(
          'Annual Percentage Rate (APR) for Cash Advances',
          '35.88%*',
          valueBold: true,
        ),
        _tilaRow(
          'Annual Percentage Rate (APR) for Balance Transfers',
          '35.88%*',
          valueBold: true,
        ),
        _tilaRow(
          'Penalty APR and When it Applies',
          '35.88%*\n\nThis APR may be applied to your account if you:\n\n  •  Fail to make the Minimum Payment on or before the due date.\n\nHow Long Will the Penalty APR Apply?: If your APR is increased, the Penalty APR will apply until you make six (6) consecutive minimum monthly payments on time.',
          valueBold: false,
          firstLinesBold: 1,
        ),
        _tilaRow(
          'Paying Interest',
          'Your due date is at least 25 days after the close of each billing cycle. We will not charge you any interest on purchases if you pay your entire balance by the due date each month. We will begin charging interest on cash advances and balance transfers on the transaction date.',
        ),
        _tilaRow(
          'For Credit Card Tips from the Consumer Financial Protection Bureau',
          'To learn more about factors to consider when applying for or using a credit card, visit the website of the Consumer Financial Protection Bureau at http://www.consumerfinance.gov/learnmore.',
          valueBold: true,
        ),
        _sectionHeader('Fees'),
        _tilaRow(
          'Annual Fee',
          '\$40–\$69 based on product, billed annually on the month of account opening, with the initial fee charged on the date of your first statement.',
        ),
        _tilaRow(
          'Transaction Fees\n· Foreign Transactions\n· Balance Transfers\n· Cash Advances',
          '\n3% of the transaction amount, in U.S. dollars\n\$5 or 5% of the amount of balance transfer, whichever is greater\n\$3 or 3% of the amount of cash advance, whichever is greater',
          labelBold: true,
          valueBold: true,
        ),
        _tilaRow(
          'Penalty Fees\n· Late Payment\n· Returned Payment\n· Overlimit',
          '\nUp to \$20\nUp to \$25\nNone',
          labelBold: true,
          valueBold: true,
        ),
        const SizedBox(height: 16),
        _footnoteRow(
          'How We Will Calculate Your Balance:',
          ' We use a method called the "average daily balance (including new transactions)." See your account agreement for more details.',
        ),
        const SizedBox(height: 8),
        _footnoteRow(
          'Billing Rights:',
          ' Information on your rights to dispute transactions and how to exercise those rights is provided in your account agreement.',
        ),
        const SizedBox(height: 12),
        Text(
          '*Maximum Annual Percentage rate will be 34.88% in Nevada',
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 11,
            fontStyle: FontStyle.italic,
            color: AppColors.neutralN500,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String label) {
    return Container(
      width: double.infinity,
      color: AppColors.navy,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _tilaRow(
    String label,
    String value, {
    bool labelBold = true,
    bool valueBold = false,
    int firstLinesBold = 0,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Label column — 38% width
          Flexible(
            flex: 38,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.neutralN100),
                  right: BorderSide(color: AppColors.neutralN100),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 12,
                  fontWeight:
                      labelBold ? FontWeight.w700 : FontWeight.w400,
                  color: AppColors.navy,
                  height: 1.5,
                ),
              ),
            ),
          ),
          // Value column — 62% width
          Flexible(
            flex: 62,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.neutralN100),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 12,
                  fontWeight:
                      valueBold ? FontWeight.w700 : FontWeight.w400,
                  color: AppColors.navy,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footnoteRow(String boldPart, String rest) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 12,
          color: AppColors.navy,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: boldPart,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: rest),
        ],
      ),
    );
  }
}
