import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../models/vehicle.dart';
import '../widgets/tlo_recommendation_banner.dart';
import '../widgets/vehicle_selection_card.dart';
import 'vehicle_details_screen.dart';

/// TLO — VehicleIdLicensePlateScreen
///
/// Step 1/5 of the TLO application flow.
/// The user selects which of their vehicles to use for the application.
///
/// Usage:
///   Navigator.push(context, MaterialPageRoute(
///     builder: (_) => const VehicleIdLicensePlateScreen(),
///   ));

class VehicleIdLicensePlateScreen extends StatefulWidget {
  const VehicleIdLicensePlateScreen({
    super.key,
    this.vehicles = SampleVehicles.all,
    this.onContinue,
    this.onBack,
    this.onNeedHelp,
    this.onAddCarManually,
  });

  final List<Vehicle> vehicles;
  final ValueChanged<Vehicle>? onContinue;
  final VoidCallback? onBack;
  final VoidCallback? onNeedHelp;
  final VoidCallback? onAddCarManually;

  @override
  State<VehicleIdLicensePlateScreen> createState() =>
      _VehicleIdLicensePlateScreenState();
}

class _VehicleIdLicensePlateScreenState
    extends State<VehicleIdLicensePlateScreen> {
  late String _selectedId;

  @override
  void initState() {
    super.initState();
    // Default to recommended vehicle, or first in list
    final recommended = widget.vehicles.where((v) => v.isRecommended).firstOrNull;
    _selectedId = (recommended ?? widget.vehicles.first).id;
  }

  Vehicle? get _selectedVehicle =>
      widget.vehicles.where((v) => v.id == _selectedId).firstOrNull;

  @override
  Widget build(BuildContext context) {
    return KBaseScreenMultiLayout(
      showStatusBar: true,
      contentPadding: 0,
      appBar: _TloNavBar(
        onBack: widget.onBack ?? () => Navigator.of(context).maybePop(),
        onNeedHelp: widget.onNeedHelp,
      ),
      content: [
        // ── Page header ──────────────────────────────────
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: _PageHeader(),
        ),

        const SizedBox(height: AppSpacing.md),

        // ── Info banner ──────────────────────────────────
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: TloRecommendationBanner(),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Vehicle cards ────────────────────────────────
        ...widget.vehicles.map((vehicle) => Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.screenPaddingH,
                right: AppSpacing.screenPaddingH,
                bottom: AppSpacing.sm,
              ),
              child: VehicleSelectionCard(
                vehicle: vehicle,
                isSelected: _selectedId == vehicle.id,
                onTap: () => setState(() => _selectedId = vehicle.id),
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VehicleDetailsScreen(vehicle: vehicle),
                  ),
                ),
              ),
            )),

        const SizedBox(height: AppSpacing.md),

        // ── "Add my car manually" link ────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: AppButton(
            label: 'Add my car manually',
            variant: AppButtonVariant.link,
            showIcon: true,
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              size: 18,
              color: AppColors.navy,
            ),
            onPressed: widget.onAddCarManually ??
                () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VehicleDetailsScreen(),
                      ),
                    ),
          ),
        ),

        const SizedBox(height: AppSpacing.xl),
      ],
      footer: _BottomBar(
        onContinue: _selectedVehicle != null
            ? () => widget.onContinue?.call(_selectedVehicle!)
            : null,
      ),
      hasStickyFooter: true,
    );
  }
}

// ── Custom TLO nav bar ─────────────────────────────────────

class _TloNavBar extends StatelessWidget implements PreferredSizeWidget {
  const _TloNavBar({
    required this.onBack,
    this.onNeedHelp,
  });

  final VoidCallback onBack;
  final VoidCallback? onNeedHelp;

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Back button with circular border
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.neutralN200,
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                size: 20,
                color: AppColors.navy,
              ),
            ),
          ),

          const Spacer(),

          // "Need Help?" outlined pill button
          GestureDetector(
            onTap: onNeedHelp,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: AppColors.neutralN100,
                  width: 1,
                ),
              ),
              child: const Text(
                'Need Help?',
                style: TextStyle(
                  fontFamily: 'PPNeueMontreal',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.navy,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Page header ────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Text(
        'Select vehicle for application',
        style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── Bottom sticky bar ──────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({this.onContinue});

  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress bar — 1/5 complete
        AppProgressBar(
          currentStep: 1,
          totalSteps: 5,
          height: 3,
          animated: false,
        ),

        // Divider
        const Divider(height: 1, thickness: 1, color: AppColors.neutralN100),

        // Button container
        Container(
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingH,
            vertical: AppSpacing.md,
          ),
          child: AppButton(
            label: 'Select vehicle and continue',
            variant: AppButtonVariant.alternate,
            isFullWidth: true,
            onPressed: onContinue,
          ),
        ),
      ],
    );
  }
}
