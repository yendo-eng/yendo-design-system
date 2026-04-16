import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../design_system/design_system.dart';

/// Shared blue info banner used on TLO vehicle selection screens.

class TloRecommendationBanner extends StatelessWidget {
  const TloRecommendationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE9FAFF),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SvgPicture.asset(
              'assets/svgs/vehicles/info_icon.svg',
              width: 16,
              height: 16,
            ),
          ),
          Expanded(
            child: Text(
              'Our recommendations guide you toward your potential highest credit limit.',
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 13,
                color: const Color(0xFF2E4457),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
