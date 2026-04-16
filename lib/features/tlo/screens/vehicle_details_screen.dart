import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../design_system/design_system.dart';
import '../models/vehicle.dart';
import 'vehicle_confirmation_screen.dart';

/// TLO — VehicleDetailsScreen
///
/// "Enter vehicle information" form screen.
/// Used for both "Add my car manually" (vehicle == null) and
/// "Edit" flows (vehicle pre-fills available data).

class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({
    super.key,
    this.vehicle,
    this.onBack,
    this.onNeedHelp,
  });

  final Vehicle? vehicle;
  final VoidCallback? onBack;
  final VoidCallback? onNeedHelp;

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final _plateController   = TextEditingController();
  final _mileageController = TextEditingController();

  String? _selectedState;
  String? _selectedColor;
  String? _selectedCondition;

  bool get _canContinue =>
      (_selectedState?.isNotEmpty ?? false) &&
      _plateController.text.isNotEmpty &&
      _mileageController.text.isNotEmpty &&
      (_selectedColor?.isNotEmpty ?? false) &&
      (_selectedCondition?.isNotEmpty ?? false);

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      _selectedState          = 'CA';
      _plateController.text   = '8TRK492';
      _mileageController.text = '54,200';
      _selectedColor          = 'Gray';
      _selectedCondition      = 'Good';
    }
  }

  @override
  void dispose() {
    _plateController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

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
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Text('Enter vehicle information', style: AppTextStyles.heading3),
        ),

        const SizedBox(height: AppSpacing.sm),

        // ── Info banner ──────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const _InfoBanner(
            text: 'If you have multiple cars, we recommend starting with one that\'s paid off.',
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Form fields ───────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _InlineDropdown(
                label: 'State',
                value: _selectedState,
                options: _usStates,
                onChanged: (v) => setState(() => _selectedState = v),
              ),

              const SizedBox(height: AppSpacing.md),

              _InlineTextField(
                label: 'License plate',
                hint: 'e.g. 7ABC123',
                controller: _plateController,
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: AppSpacing.md),

              _InlineTextField(
                label: 'Mileage',
                hint: 'e.g. 45,000',
                controller: _mileageController,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: AppSpacing.md),

              _InlineDropdown(
                label: 'Color',
                value: _selectedColor,
                options: _colors,
                onChanged: (v) => setState(() => _selectedColor = v),
              ),

              const SizedBox(height: AppSpacing.md),

              _InlineDropdown(
                label: 'Vehicle condition',
                value: _selectedCondition,
                options: _conditions,
                onChanged: (v) => setState(() => _selectedCondition = v),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xl),
      ],
      footer: _BottomSection(
        canContinue: _canContinue,
        onContinue: () {
          if (widget.vehicle != null) {
            // Edit flow — go back to vehicle selection
            Navigator.of(context).pop();
          } else {
            // Add manually flow — show confirmation screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const VehicleConfirmationScreen(),
              ),
            );
          }
        },
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

// ── Info banner ────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE9FAFF),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SvgPicture.asset(
              'assets/svgs/vehicles/info_icon.svg',
              width: 16,
              height: 16,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'PPNeueMontreal',
                fontWeight: FontWeight.w400,
                fontSize: 13,
                height: 1.5,
                color: Color(0xFF2E4457),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Inline text field ──────────────────────────────────────
//
// Custom field: small label pinned inside at top, text input
// below. Uses a Container border so there's no Material hover
// gray effect.

class _InlineTextField extends StatefulWidget {
  const _InlineTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  State<_InlineTextField> createState() => _InlineTextFieldState();
}

class _InlineTextFieldState extends State<_InlineTextField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _focused ? AppColors.navy : AppColors.neutralN200,
          width: _focused ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontFamily: 'PPNeueMontreal',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.neutralN500,
              height: 1.6,
            ),
          ),
          Focus(
            onFocusChange: (f) => setState(() => _focused = f),
            child: TextField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              onChanged: widget.onChanged,
              style: const TextStyle(
                fontFamily: 'PPNeueMontreal',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.navy,
                height: 1.43,
              ),
              decoration: InputDecoration.collapsed(
                hintText: widget.hint,
                hintStyle: const TextStyle(
                  fontFamily: 'PPNeueMontreal',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.neutralN500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Inline dropdown ────────────────────────────────────────
//
// Small label pinned at top, selected value below, chevron
// right. Same Container border — no hover gray effect.

class _InlineDropdown extends StatelessWidget {
  const _InlineDropdown({
    required this.label,
    required this.options,
    required this.onChanged,
    this.value,
  });

  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.neutralN200),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'PPNeueMontreal',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.neutralN500,
                      height: 1.6,
                    ),
                  ),
                  Text(
                    value ?? '',
                    style: TextStyle(
                      fontFamily: 'PPNeueMontreal',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: value != null
                          ? AppColors.navy
                          : AppColors.neutralN500,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: AppColors.neutralN500,
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ListView(
        shrinkWrap: true,
        children: options
            .map((o) => ListTile(
                  title: Text(
                    o,
                    style: const TextStyle(
                      fontFamily: 'PPNeueMontreal',
                      fontSize: 15,
                      color: AppColors.navy,
                    ),
                  ),
                  trailing: o == value
                      ? const Icon(Icons.check_rounded, color: AppColors.navy)
                      : null,
                  onTap: () {
                    onChanged(o);
                    Navigator.pop(context);
                  },
                ))
            .toList(),
      ),
    );
  }
}

// ── Bottom section ─────────────────────────────────────────

class _BottomSection extends StatelessWidget {
  const _BottomSection({required this.canContinue, required this.onContinue});
  final bool canContinue;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Reminder banner — edge-to-edge
        Container(
          width: double.infinity,
          color: AppColors.neutralN50,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 2),
                child: SvgPicture.asset(
                  'assets/svgs/vehicles/star_icon.svg',
                  width: 24,
                  height: 24,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Not able to enter your vehicle details right now?',
                      style: TextStyle(
                        fontFamily: 'PPNeueMontreal',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 1.43,
                        color: Color(0xFF2E4457),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Set a reminder',
                      style: TextStyle(
                        fontFamily: 'PPNeueMontreal',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.43,
                        color: Color(0xFF0053B4),
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFF0053B4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Progress bar — edge-to-edge
        AppProgressBar(
          currentStep: 1,
          totalSteps: 5,
          height: 3,
          animated: false,
        ),

        const Divider(height: 1, thickness: 1, color: AppColors.neutralN100),

        // CTA — edge-to-edge
        Container(
          width: double.infinity,
          color: AppColors.white,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: AppButton(
            label: 'Save and continue',
            variant: AppButtonVariant.alternate,
            isFullWidth: true,
            onPressed: canContinue ? onContinue : null,
          ),
        ),
      ],
    );
  }
}

// ── Static data ────────────────────────────────────────────

const _usStates = [
  'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA',
  'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD',
  'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ',
  'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC',
  'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY',
];

const _colors = [
  'Black', 'White', 'Silver', 'Gray', 'Red', 'Blue',
  'Brown', 'Green', 'Orange', 'Gold', 'Yellow', 'Other',
];

const _conditions = [
  'Excellent', 'Very Good', 'Good', 'Fair', 'Poor',
];
