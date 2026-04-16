import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../design_system/design_system.dart';
import '../models/vehicle.dart';

/// TLO Concept B — VehicleSelectionCardB
///
/// • "Recommended" pill spans full card width (left-aligned to card edge)
/// • Vehicle silhouette leads on the left, name/trim to its right
/// • Edit affordance: pencil icon only, pinned to the right, top-aligned

class VehicleSelectionCardB extends StatelessWidget {
  const VehicleSelectionCardB({
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
        child: _cardLayout(),
      ),
    );
  }

  // ── Shared badge widget ────────────────────────────────
  Widget _badge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
      );

  // ── Shared silhouette widget ───────────────────────────
  Widget _silhouette() => Transform.scale(
        scaleX: -1,
        child: SvgPicture.asset(
          _svgPath,
          width: 38,
          height: 17,
          colorFilter: const ColorFilter.mode(
            Color(0xFF4D6173),
            BlendMode.srcIn,
          ),
        ),
      );

  // ── Pencil icon widget ─────────────────────────────────
  Widget _pencil() => GestureDetector(
        onTap: onEdit,
        behavior: HitTestBehavior.opaque,
        child: const Icon(
          Icons.edit_outlined,
          size: 15,
          color: AppColors.neutralN500,
        ),
      );

  // ── Card layout ────────────────────────────────────────
  // Recommended: pencil in the make/model row (taller card due to badge)
  // Non-recommended: pencil centered to full card height via Stack
  Widget _cardLayout() {
    final contentRow = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _silhouette(),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      vehicle.displayName,
                      style: AppTextStyles.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Pencil inline for recommended cards only
                  if (vehicle.isRecommended && onEdit != null) ...[
                    const SizedBox(width: 8),
                    _pencil(),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                vehicle.trim,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                  height: 1.33,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (vehicle.isRecommended) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _badge(),
          const SizedBox(height: 10),
          contentRow,
        ],
      );
    }

    // Non-recommended: pencil floated to card center-right via Stack
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(right: onEdit != null ? 24.0 : 0),
          child: contentRow,
        ),
        if (onEdit != null)
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: _pencil(),
            ),
          ),
      ],
    );
  }

  String get _svgPath {
    switch (vehicle.type) {
      case VehicleType.suv:
        return 'assets/svgs/vehicles/vehicle_suv.svg';
      case VehicleType.truck:
        return 'assets/svgs/vehicles/vehicle_truck.svg';
      case VehicleType.sedan:
        return 'assets/svgs/vehicles/vehicle_sedan.svg';
    }
  }
}
