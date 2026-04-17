import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import 'auto_refi_final_offer_v2a.dart';

/// Auto Refi v2 Fast Follows — prototype hub.
///
/// Lists all three final offer screen variations for quick side-by-side review.
/// Branch: auto-refi-v2-fast-follows

class AutoRefiV2Hub extends StatelessWidget {
  const AutoRefiV2Hub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralN50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPaddingH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto Refi v2',
                      style: AppTextStyles.h2.copyWith(color: AppColors.white),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Fast follows — Final offer screen variations',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Text(
                'Select a variation to preview',
                style: AppTextStyles.body2.copyWith(color: AppColors.neutralN500),
              ),

              const SizedBox(height: AppSpacing.md),

              // Variation A
              _VariationTile(
                label: 'Variation A',
                tag: 'Card-first',
                description:
                    'Logo nav · Full-width card image · Separate credit card '
                    'benefits + refinance details sections · Monthly payment hero',
                wireframe: 'Wireframe 1',
                accentColor: AppColors.primaryO400,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AutoRefiFinalOfferV2A(),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Variation B
              _VariationTile(
                label: 'Variation B',
                tag: 'Approval-first',
                description:
                    '"You\'re approved!" heading · Compact card with small '
                    'card art · Full 5-item benefit list · Minimal layout',
                wireframe: 'Wireframe 2',
                accentColor: AppColors.blue600,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AutoRefiFinalOfferV2B(),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Variation C
              _VariationTile(
                label: 'Variation C',
                tag: 'Hybrid',
                description:
                    'Logo nav · Full-width card hero · Single combined card '
                    'showing credit limit + monthly payment + benefits',
                wireframe: 'Hybrid of both',
                accentColor: AppColors.green400,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AutoRefiFinalOfferV2C(),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tile widget ───────────────────────────────────────────────────────────────

class _VariationTile extends StatelessWidget {
  const _VariationTile({
    required this.label,
    required this.tag,
    required this.description,
    required this.wireframe,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final String tag;
  final String description;
  final String wireframe;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.neutralN100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color accent strip
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: AppTextStyles.bodyRegular.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                        ),
                        child: Text(
                          tag,
                          style: AppTextStyles.caption.copyWith(
                            color: accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.neutralN500,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '↗ $wireframe',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.contentDisabled,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.neutralN500,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
