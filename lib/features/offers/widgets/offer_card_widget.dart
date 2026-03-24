import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../design_system/design_system.dart';
import '../models/card_offer.dart';

/// A selectable offer card used on both the 3-offers screen and downsell screens.
///
/// Tapping the card selects it (highlighted border + checkmark).
/// "View terms" opens a bottom sheet with the full legal terms.
///
/// Usage:
///   OfferCardWidget(
///     offer: YendoOffers.vehicle,
///     isSelected: _selectedOffer == YendoOffers.vehicle,
///     onTap: () => setState(() => _selectedOffer = YendoOffers.vehicle),
///     showCreditLimit: true,
///   )

class OfferCardWidget extends StatelessWidget {
  const OfferCardWidget({
    super.key,
    required this.offer,
    required this.isSelected,
    required this.onTap,
    this.showCreditLimit = false,
    this.showBulletPoints = true,
    this.showRecommended = false,
    this.showApr = true,
    this.showViewTerms = true,
    this.subtitle,
    this.nameOverride,
  });

  final CardOffer offer;
  final bool isSelected;
  final VoidCallback onTap;

  /// Show credit limit + APR (used on downsell screens)
  final bool showCreditLimit;

  /// Show bullet points (used on the initial 3-offers screen)
  final bool showBulletPoints;

  /// Show the "Recommended" pill badge above the card name
  final bool showRecommended;

  /// Show APR row inside the card (only applies when showCreditLimit is true)
  final bool showApr;

  /// Show the "View terms" link inside the card
  final bool showViewTerms;

  /// Optional paragraph copy shown below the card name
  final String? subtitle;

  /// Override the displayed card name (e.g. for bundle variants)
  final String? nameOverride;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.neutralN500 : AppColors.neutralN100,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.neutralN500.withValues(alpha: 0.18),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Text content ─────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Recommended" badge
                  if (showRecommended) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryO400,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Recommended',
                        style: TextStyle(
                          fontFamily: 'PPNeueMontreal',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                  ],

                  // Name
                  Text(
                    nameOverride ?? offer.name,
                    style: AppTextStyles.bodyRegular.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),

                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutralN500,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.xs),

                  // Bullet points (initial screen)
                  // Order: pre-approved amount, cash advance, APR, rewards
                  if (showBulletPoints) ...[
                    ...[
                      offer.bulletPoints.first, // Pre-approved up to $X
                      'Cash advance limit ${offer.cashAdvanceLimit}',
                      'APR ${offer.apr}',
                      offer.rewardsLine, // 1.5% rewards on Autopay
                    ].map((point) => Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.neutralN500,
                                  )),
                              Expanded(
                                child: Text(
                                  point,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.neutralN500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],

                  // Credit limit + APR (downsell screens)
                  if (showCreditLimit) ...[
                    Text(
                      'Credit Limit',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutralN500,
                        fontSize: 12,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      offer.creditLimit,
                      style: AppTextStyles.spaceGrotesk(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (showApr) ...[
                      const SizedBox(height: 4),
                      Text(
                        'APR ${offer.apr}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.neutralN500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],

                  if (showViewTerms) ...[
                    const SizedBox(height: AppSpacing.sm),

                    // View terms link
                    GestureDetector(
                      onTap: () => _showTerms(context),
                      child: Text(
                        'View terms',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: AppColors.contentDisabled,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.contentDisabled,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // ── Card image ───────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: SvgPicture.asset(
                offer.imagePath,
                width: 80,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTerms(BuildContext context) {
    showAppBottomSheet(
      context: context,
      title: offer.name,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Text(
          offer.terms,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.neutralN500,
            height: 1.6,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
