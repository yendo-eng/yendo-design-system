import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';

/// TLO — VehicleConfirmationScreen
///
/// "We found your vehicle!" screen shown after the manual
/// license plate entry form. Displays the looked-up vehicle
/// details for the user to confirm.

class VehicleConfirmationScreen extends StatelessWidget {
  const VehicleConfirmationScreen({
    super.key,
    this.make     = 'Toyota',
    this.model    = 'Corolla',
    this.trim     = 'Trx Lxve',
    this.color    = 'Black',
    this.vin      = '12FGRYSHUIOSNYHHOHENE',
    this.onBack,
    this.onNeedHelp,
    this.onConfirm,
    this.onReject,
  });

  final String make;
  final String model;
  final String trim;
  final String color;
  final String vin;

  final VoidCallback? onBack;
  final VoidCallback? onNeedHelp;

  /// "Yes, this is my vehicle" — navigates to TLO home.
  final VoidCallback? onConfirm;

  /// "No, this is not my vehicle" — goes back.
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    return KBaseScreenMultiLayout(
      showStatusBar: true,
      contentPadding: 0,
      appBar: _TloNavBar(
        onBack: onBack ?? () => Navigator.of(context).maybePop(),
        onNeedHelp: onNeedHelp,
      ),
      content: [
        // ── Page header ──────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We found your vehicle!',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 8),
              Text(
                'Here is what we found based on the information you provided',
                style: TextStyle(
                  fontFamily: 'PPNeueMontreal',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: AppColors.neutralN500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ── Vehicle info rows ─────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _InfoRow(label: 'Make',  value: make),
              _InfoRow(label: 'Model', value: model),
              _InfoRow(label: 'Trim',  value: trim),
              _InfoRow(label: 'Color', value: color),
              _InfoRow(label: 'VIN',   value: vin, showDivider: false),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xl),
      ],
      footer: _BottomBar(
        onConfirm: onConfirm ??
            () => Navigator.of(context).popUntil((r) => r.isFirst),
        onReject: onReject ?? () => Navigator.of(context).maybePop(),
      ),
      hasStickyFooter: true,
    );
  }
}

// ── Nav bar ────────────────────────────────────────────────

class _TloNavBar extends StatelessWidget implements PreferredSizeWidget {
  const _TloNavBar({required this.onBack, this.onNeedHelp});

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
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.neutralN200),
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                size: 20,
                color: AppColors.navy,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onNeedHelp,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppColors.neutralN100),
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

// ── Info row ───────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'PPNeueMontreal',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.neutralN500,
                  height: 1.43,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'PPNeueMontreal',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.navy,
                  height: 1.43,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: AppColors.neutralN100),
      ],
    );
  }
}

// ── Bottom bar ─────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onConfirm, required this.onReject});

  final VoidCallback onConfirm;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppProgressBar(
          currentStep: 1,
          totalSteps: 5,
          height: 3,
          animated: false,
        ),

        const Divider(height: 1, thickness: 1, color: AppColors.neutralN100),

        Container(
          color: AppColors.white,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            children: [
              AppButton(
                label: 'Yes, this is my vehicle',
                variant: AppButtonVariant.alternate,
                isFullWidth: true,
                onPressed: onConfirm,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: 'No, this is not my vehicle',
                variant: AppButtonVariant.tertiary,
                isFullWidth: true,
                onPressed: onReject,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
