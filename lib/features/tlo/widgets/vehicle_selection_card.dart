import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../design_system/design_system.dart';
import '../models/vehicle.dart';

/// TLO — VehicleSelectionCard
///
/// A selectable card showing a user's vehicle with make/model/trim.
/// Tapping the card selects it (highlighted navy border + heavier shadow).
/// The recommended card shows an orange "Recommended" pill badge.
///
/// Usage:
///   VehicleSelectionCard(
///     vehicle: SampleVehicles.all.first,
///     isSelected: _selectedId == 'rav4',
///     onTap: () => setState(() => _selectedId = 'rav4'),
///     onEdit: () {},
///   )

class VehicleSelectionCard extends StatelessWidget {
  const VehicleSelectionCard({
    super.key,
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
    this.onEdit,
  });

  final Vehicle vehicle;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onEdit;

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
            color: isSelected ? AppColors.navy : AppColors.neutralN100,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: const Color(0xFF4D6173).withValues(alpha: 0.18),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Left: text content ────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Recommended" badge
                  if (vehicle.isRecommended) ...[
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
                    const SizedBox(height: 4),
                  ],

                  // Year / Make / Model
                  Text(
                    vehicle.displayName,
                    style: AppTextStyles.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Trim + Edit link
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        vehicle.trim,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                          height: 1.33,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (onEdit != null)
                        GestureDetector(
                          onTap: onEdit,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.edit_outlined,
                                size: 14,
                                color: Color(0xFF0E4780),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'Edit',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0E4780),
                                  decoration: TextDecoration.underline,
                                  decorationColor: const Color(0xFF0E4780),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // ── Right: vehicle icon ────────────────────────
            _VehicleIcon(type: vehicle.type),
          ],
        ),
      ),
    );
  }
}

// ── Vehicle icon ───────────────────────────────────────────

class _VehicleIcon extends StatelessWidget {
  const _VehicleIcon({required this.type});

  final VehicleType type;

  static const _svgPaths = {
    VehicleType.suv:   'assets/svgs/vehicles/vehicle_suv.svg',
    VehicleType.truck: 'assets/svgs/vehicles/vehicle_truck.svg',
    VehicleType.sedan: 'assets/svgs/vehicles/vehicle_sedan.svg',
  };

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: -1,
      child: SvgPicture.asset(
        _svgPaths[type]!,
        width: 60,
        height: 24,
        colorFilter: const ColorFilter.mode(
          Color(0xFF4D6173),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
