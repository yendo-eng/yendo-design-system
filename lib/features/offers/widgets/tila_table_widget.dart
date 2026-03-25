import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';

/// TILA disclosure table — Interest Rates and Fees.
/// Shared between Option A (View Terms sheet) and Option D (inline on page).
class TilaDisclosureTable extends StatelessWidget {
  const TilaDisclosureTable({super.key});

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
          fontWeight: FontWeight.w500,
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
                  fontWeight: labelBold ? FontWeight.w500 : FontWeight.w400,
                  color: AppColors.navy,
                  height: 1.5,
                ),
              ),
            ),
          ),
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
                  fontWeight: valueBold ? FontWeight.w500 : FontWeight.w400,
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
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          TextSpan(text: rest),
        ],
      ),
    );
  }
}
