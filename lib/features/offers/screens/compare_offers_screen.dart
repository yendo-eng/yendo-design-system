import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../models/card_offer.dart';

/// Compare Offers screen
///
/// Uses AppComparisonTable to show all 4 Yendo products side by side,
/// matching the product comparison table used by the team.

class CompareOffersScreen extends StatelessWidget {
  const CompareOffersScreen({
    super.key,
    required this.offers,
  });

  final List<CardOffer> offers;

  @override
  Widget build(BuildContext context) {
    return KBaseScreenMultiLayout(
      showStatusBar: true,
      contentBackgroundColor: AppColors.neutralN50,
      appBar: const AppNavBar.logo(),
      content: [
        const SizedBox(height: AppSpacing.sm),
        CompareOffersScreen.buildComparisonTable(offers),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  /// Builds a 4-column comparison table using all Yendo products.
  /// The [offers] param is kept for API compatibility — the table always
  /// shows all 4 products per the product comparison spec.
  static Widget buildComparisonTable(List<CardOffer> offers) {
    final products = offers.isNotEmpty ? offers : YendoOffers.all;

    final options = products
        .map((o) => o.name.split(' ').join('\n'))
        .toList();

    final rows = [
      ComparisonRow(
        label: 'APR',
        values: products.map((o) => o.apr).toList(),
      ),
      ComparisonRow(
        label: 'Credit Limit',
        values: products.map((o) => o.creditLimit).toList(),
      ),
      ComparisonRow(
        label: 'Daily cash\nadvance limit',
        values: products.map((o) => o.cashAdvanceLimit).toList(),
      ),
      ComparisonRow(
        label: 'Rewards',
        values: products.map((o) => o.rewardsLine).toList(),
      ),
      ComparisonRow(
        label: 'Powered\nby',
        values: products.map((o) {
          if (o.name == 'Platinum Rewards') return 'Vehicle';
          if (o.name == 'Signature Rewards') return 'Home fixture*';
          return 'N/A';
        }).toList(),
      ),
    ];

    final table = products.length == 2
        ? AppComparisonTable.twoColumn(options: options, rows: rows)
        : AppComparisonTable.threeColumn(options: options, rows: rows);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        table,
        const SizedBox(height: 16),
        Text(
          '*Home fixture examples include cabinets and HVACs.',
          style: TextStyle(
            fontFamily: 'PPNeueMontreal',
            fontSize: 12,
            color: Color(0xFF6B7A8D),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
