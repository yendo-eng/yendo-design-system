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
    this.showAnnualFee = false,
    this.showViewTerms = true,
    this.showAprBullet = true,
    this.showRewardsBullet = true,
    this.subtitle,
    this.nameOverride,
    this.callout,
    this.extraBottomPadding = 0.0,
    this.imageScale = 1.0,
    this.benefitLine,
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

  /// Show Annual Fee row inside the card (only applies when showCreditLimit is true)
  final bool showAnnualFee;

  /// Show the "View terms" link inside the card
  final bool showViewTerms;

  /// Show APR bullet point (default true)
  final bool showAprBullet;

  /// Show rewards bullet point (default true)
  final bool showRewardsBullet;

  /// Optional paragraph copy shown below the card name
  final String? subtitle;

  /// Override the displayed card name (e.g. for bundle variants)
  final String? nameOverride;

  /// Optional widget rendered below the main card row (e.g. a savings callout banner)
  final Widget? callout;

  /// Extra padding added to the bottom of the card content (makes card taller)
  final double extraBottomPadding;

  /// Scale applied to the card image size (1.0 = default 80×56, 0.85 = 68×48)
  final double imageScale;

  /// When provided, replaces the APR/Annual Fee line with custom benefit copy.
  final String? benefitLine;

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
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md + extraBottomPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Main row: text left, card image right ────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                      // Card name
                      Text(
                        nameOverride ?? offer.name,
                        style: AppTextStyles.bodyRegular.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),

                      // ── When NO callout: keep all content inside the
                      //    Row column so the image aligns with it (original layout)
                      if (callout == null) ...[
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

                        if (showBulletPoints) ...[
                          ...[
                            offer.bulletPoints.first,
                            'Cash advance limit ${offer.cashAdvanceLimit}',
                            if (showAprBullet) 'APR ${offer.apr}',
                            if (showRewardsBullet) offer.rewardsLine,
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
                          if (showApr ||
                              (showAnnualFee && offer.annualFee != null)) ...[
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.neutralN500,
                                  fontSize: 13,
                                ),
                                children: [
                                  if (showApr)
                                    TextSpan(text: 'APR ${offer.apr}'),
                                  if (showApr &&
                                      showAnnualFee &&
                                      offer.annualFee != null)
                                    TextSpan(
                                      text: '  |  ',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.neutralN200,
                                        fontSize: 13,
                                      ),
                                    ),
                                  if (showAnnualFee && offer.annualFee != null)
                                    TextSpan(
                                        text: 'Annual fee: ${offer.annualFee}'),
                                ],
                              ),
                            ),
                          ],
                        ],

                        if (showViewTerms) ...[
                          const SizedBox(height: AppSpacing.sm),
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
                    ],
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                // Card image
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  child: SvgPicture.asset(
                    offer.imagePath,
                    width: 80 * imageScale,
                    height: 56 * imageScale,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),

            // ── Benefit line — full width below the card image row ──────────
            if (benefitLine != null && callout == null) ...[
              const SizedBox(height: 6),
              Text(
                benefitLine!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.neutralN500,
                  fontSize: 13,
                ),
              ),
            ],

            // ── When callout IS present: full-width content below the row ──
            if (callout != null) ...[
              const SizedBox(height: AppSpacing.xs),
              callout!,
              const SizedBox(height: AppSpacing.xs + 2),

              if (subtitle != null) ...[
                Text(
                  subtitle!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.neutralN500,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],

              if (showBulletPoints) ...[
                ...[
                  offer.bulletPoints.first,
                  'Cash advance limit ${offer.cashAdvanceLimit}',
                  if (showAprBullet) 'APR ${offer.apr}',
                  if (showRewardsBullet) offer.rewardsLine,
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
                if (showApr || (showAnnualFee && offer.annualFee != null)) ...[
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutralN500,
                        fontSize: 13,
                      ),
                      children: [
                        if (showApr) TextSpan(text: 'APR ${offer.apr}'),
                        if (showApr && showAnnualFee && offer.annualFee != null)
                          TextSpan(
                            text: '  |  ',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.neutralN200,
                              fontSize: 13,
                            ),
                          ),
                        if (showAnnualFee && offer.annualFee != null)
                          TextSpan(text: 'Annual fee: ${offer.annualFee}'),
                      ],
                    ),
                  ),
                ],
              ],

              if (showViewTerms) ...[
                const SizedBox(height: AppSpacing.sm),
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
          ],
        ),   // end outer Column
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
