import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';

/// Denial screen — shown when Yendo rejects because the applicant
/// is not listed as an owner on the property (Homeowner denial, no downsell).
class HomeownerDenialScreen extends StatelessWidget {
  const HomeownerDenialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KBaseScreenMultiLayout(
      showStatusBar: true,
      statusBarBackgroundColor: AppColors.white,
      contentBackgroundColor: AppColors.white,
      appBar: AppNavBar.logo(backgroundColor: AppColors.white),
      contentPadding: 0,
      hasStickyFooter: true,
      footer: AppStickyBottomBar(
        primaryLabel: 'Apply again',
        primaryVariant: AppButtonVariant.alternate,
        onPrimary: () =>
            Navigator.of(context).popUntil((route) => route.isFirst),
        secondaryLabel: 'Done',
        secondaryVariant: AppButtonVariant.link,
        onSecondary: () =>
            Navigator.of(context).popUntil((route) => route.isFirst),
        backgroundColor: AppColors.white,
      ),
      content: [
        const SizedBox(height: AppSpacing.md),

        // ── Illustration ─────────────────────────────────
        Center(
          child: Container(
            width: 200,
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.primaryO400.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_outlined,
                  size: 64,
                  color: AppColors.primaryO400,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Come Back Soon!',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryO400,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.x3l),

        // ── Copy ─────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingH,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We were not able to approve you for a Signature Rewards.',
                style: AppTextStyles.heading3.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              Text(
                'You were not listed as an owner on this property.',
                style: AppTextStyles.bodyRegular.copyWith(
                  color: AppColors.neutralN500,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.x3l),
      ],
    );
  }
}
