import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import 'vehicle_id_license_plate_screen.dart';
import 'vehicle_id_license_plate_screen_b.dart';

/// TLO prototype hub — lists all TLO concepts for quick navigation.

class TloHomeScreen extends StatelessWidget {
  const TloHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TLO',
                style: AppTextStyles.heading3.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                'Select a concept to preview',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.neutralN500,
                ),
              ),
              const SizedBox(height: 32),
              _ConceptTile(
                label: 'Concept A',
                description: 'Vehicle ID — Edit inline beside trim',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VehicleIdLicensePlateScreen(),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _ConceptTile(
                label: 'Concept B',
                description: 'Vehicle ID — Edit icon pinned top-right',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VehicleIdLicensePlateScreenB(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConceptTile extends StatelessWidget {
  const _ConceptTile({
    required this.label,
    required this.description,
    required this.onTap,
  });

  final String label;
  final String description;
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
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(Icons.phone_iphone_rounded,
                  size: 20, color: AppColors.white),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyRegular.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.neutralN500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.neutralN500, size: 20),
          ],
        ),
      ),
    );
  }
}
