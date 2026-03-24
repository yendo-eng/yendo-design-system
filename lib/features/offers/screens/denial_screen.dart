import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';

/// Denial screen — shown when Yendo rejects at Personal ID,
/// or when the applicant declines all downsell offers.
///
/// No downsell available from this screen.
/// Two actions: "Apply again" or "Done".

class DenialScreen extends StatelessWidget {
  const DenialScreen({super.key});

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
        onPrimary: () => Navigator.of(context).pop(),
        secondaryLabel: 'Done',
        secondaryVariant: AppButtonVariant.link,
        onSecondary: () => Navigator.of(context).pop(),
        backgroundColor: AppColors.white,
      ),
      content: [
        const SizedBox(height: AppSpacing.md),

        // ── Illustration ─────────────────────────────────
        // TODO: Replace with the "Come Back Soon" car mirror illustration
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
                  Icons.directions_car_outlined,
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
                'Unfortunately, we are not able to approve you today',
                style: AppTextStyles.heading3.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              Text(
                'Based on the information you provided, we are not able to approve you today. You can apply again with no impact to your credit score.',
                style: AppTextStyles.bodyRegular.copyWith(
                  color: AppColors.neutralN500,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              Text(
                'You will receive an email with more information regarding our decision.',
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
