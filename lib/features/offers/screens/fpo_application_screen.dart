import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../main.dart';
import '../models/card_offer.dart';
import 'downsell_screen.dart';
import 'denial_screen.dart';
import 'homeowner_denial_screen.dart';
import 'offers_selection_screen.dart';
import 'offers_selection_screen_v2.dart';
import 'verification_hub_screen.dart';
import 'offers_selection_screen_bundle.dart';

/// Application Funnel — navigation hub for all design explorations
/// and funnel simulation outcomes.
class FpoApplicationScreen extends StatelessWidget {
  const FpoApplicationScreen({
    super.key,
    required this.selectedOffer,
    required this.allOffers,
  });

  final CardOffer selectedOffer;
  final List<CardOffer> allOffers;

  List<CardOffer> get _remainingOffers =>
      CardOffer.downsellOptions(allOffers, selectedOffer);

  @override
  Widget build(BuildContext context) {
    return KBaseScreenMultiLayout(
      showStatusBar: true,
      contentBackgroundColor: const Color(0xFFFFF3E0),
      appBar: const AppNavBar.logo(),
      content: [
        const SizedBox(height: AppSpacing.md),

        // FPO badge
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.shade800,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            ),
            child: const Text(
              'FPO — For Placement Only',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        Text(
          'Application Funnel',
          style: AppTextStyles.heading3,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.x3l),

        // ── Section: Design Explorations ───────────────────
        _SectionHeader(label: 'Design Explorations'),

        const SizedBox(height: AppSpacing.sm),

        _OutcomeButton(
          label: '🆕  Verification Hub Update',
          sublabel: 'Welcome + offer card + 3-step progress',
          color: AppColors.green400,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const VerificationHubScreen(),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        _OutcomeButton(
          label: '🏠  Homeowner denial — no other offer',
          sublabel: 'Not listed as owner on property',
          color: AppColors.neutralN500,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeownerDenialScreen(),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        _OutcomeButton(
          label: '🎨  Auto Refi as Bundle',
          sublabel: 'Option A + bundled value prop on first card',
          color: AppColors.blue400,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OffersSelectionScreenBundle(offers: allOffers),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        _OutcomeButton(
          label: '🎨  Option A — Multiple offers',
          sublabel: 'Rejection style · big number cards · 3 offers',
          color: AppColors.blue400,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OffersSelectionScreenV3(offers: allOffers),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        _OutcomeButton(
          label: '🎨  Option B — Multiple offers',
          sublabel: 'Congratulations · bullet list layout',
          color: AppColors.blue400,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OffersSelectionScreen(offers: allOffers),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        _OutcomeButton(
          label: '🎨  Option C — Multiple offers',
          sublabel: 'Congratulations · big bold credit limit layout',
          color: AppColors.blue400,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OffersSelectionScreenV2(offers: allOffers),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // ── Section: Application Funnel Outcomes ───────────
        const Divider(color: AppColors.neutralN100, height: 1),
        const SizedBox(height: AppSpacing.md),

        _SectionHeader(label: 'Simulate an outcome'),

        const SizedBox(height: AppSpacing.sm),

        _OutcomeButton(
          label: '🚗  Yendo rejects at Vehicle ID',
          sublabel: 'Triggers Downsell A',
          color: AppColors.red400,
          onTap: _remainingOffers.isNotEmpty
              ? () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DownsellScreen.vehicleIdRejection(
                        remainingOffers: _remainingOffers,
                        allOffers: allOffers,
                      ),
                    ),
                  )
              : null,
          disabledLabel: 'No offers left to downsell',
        ),

        const SizedBox(height: AppSpacing.sm),

        _OutcomeButton(
          label: '🪪  Yendo rejects at Personal ID',
          sublabel: 'Triggers Denial screen',
          color: AppColors.neutralN500,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const DenialScreen(),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        _OutcomeButton(
          label: '❌  Applicant rejects Final Offer',
          sublabel: 'Triggers Downsell B',
          color: AppColors.yellow500,
          onTap: _remainingOffers.isNotEmpty
              ? () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DownsellScreen.applicantRejection(
                        remainingOffers: _remainingOffers,
                        allOffers: allOffers,
                      ),
                    ),
                  )
              : null,
          disabledLabel: 'No offers left to downsell',
        ),

        const SizedBox(height: AppSpacing.sm),

        _OutcomeButton(
          label: '✅  Applicant accepts Final Offer',
          sublabel: 'Success! Flow complete',
          color: AppColors.green400,
          onTap: () => _showSuccess(context),
        ),

        const SizedBox(height: AppSpacing.xl),

        // ── Section: Design System ─────────────────────────
        const Divider(color: AppColors.neutralN100, height: 1),
        const SizedBox(height: AppSpacing.md),

        _SectionHeader(label: 'Design System'),

        const SizedBox(height: AppSpacing.sm),

        _OutcomeButton(
          label: '🎨  Design System',
          sublabel: 'Components, tokens, and style guide',
          color: AppColors.neutralN500,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ShowcaseHome(),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  void _showSuccess(BuildContext context) {
    showAppBottomSheet(
      context: context,
      title: 'You\'re approved! 🎉',
      description:
          'Your ${selectedOffer.name} with a ${selectedOffer.creditLimit} limit is on its way. Check your email for next steps.',
      buttonLabel: 'Done',
      onButtonPressed: () => Navigator.of(context)
          .popUntil((route) => route.isFirst),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.bodySmall.copyWith(
        color: AppColors.neutralN500,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _OutcomeButton extends StatelessWidget {
  const _OutcomeButton({
    required this.label,
    required this.sublabel,
    required this.color,
    required this.onTap,
    this.disabledLabel,
  });

  final String label;
  final String sublabel;
  final Color color;
  final VoidCallback? onTap;
  final String? disabledLabel;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDisabled
              ? AppColors.neutralN75
              : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: isDisabled ? AppColors.neutralN200 : color.withOpacity(0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isDisabled
                    ? AppColors.contentDisabled
                    : AppColors.navy,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isDisabled && disabledLabel != null
                  ? disabledLabel!
                  : sublabel,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 12,
                color: isDisabled
                    ? AppColors.contentDisabled
                    : AppColors.neutralN500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
