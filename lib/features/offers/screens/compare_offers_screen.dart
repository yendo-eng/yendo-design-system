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
    // Show the 3 pre-approved products only
    final products = YendoOffers.all;

    final options = [
      'Express\nPreferred\nRewards',
      'Keystone\nReserve\nRewards',
      'Flex\nPreferred\nRewards',
    ];

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
    ];

    return AppComparisonTable.threeColumn(
      options: options,
      rows: rows,
    );
  }
}
