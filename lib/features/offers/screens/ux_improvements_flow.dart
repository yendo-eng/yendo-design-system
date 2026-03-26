import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';

// ─────────────────────────────────────────────────────────────────────────────
// UX Improvements — "Remove return to Vehicle Hub (progress indicator)"
//
// Exploration: replace the top nav-bar progress bar with an Airbnb-style
// bottom step indicator, and remove the "X → back to Hub" close button.
//
// Flow (5 screens):
//   1. Personal Information   — no step bar (pre-photo step)
//   2. Vehicle Photos         — step 1 of 4 (educational tips)
//   3. Front of Title Photo   — step 2 of 4 (educational tips)
//   4. Back of Title Photo    — step 3 of 4 (educational tips)
//   5. Vehicle Photos         — step 4 of 4 (photo grid / submitted)
// ─────────────────────────────────────────────────────────────────────────────

class UxImprovementsFlow extends StatefulWidget {
  const UxImprovementsFlow({super.key});

  @override
  State<UxImprovementsFlow> createState() => _UxImprovementsFlowState();
}

class _UxImprovementsFlowState extends State<UxImprovementsFlow> {
  int _step = 0; // 0 = Personal Info, 1-4 = photo steps

  void _next() => setState(() => _step = (_step + 1).clamp(0, 4));
  void _back() {
    if (_step == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() => _step--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (_step) {
      0 => _PersonalInfoScreen(onNext: _next, onBack: _back),
      1 => _VehiclePhotoEdScreen(onNext: _next, onBack: _back),
      2 => _FrontTitleScreen(onNext: _next, onBack: _back),
      3 => _BackTitleScreen(onNext: _next, onBack: _back),
      _ => _VehiclePhotoGridScreen(onBack: _back),
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Airbnb-style bottom step progress bar
// ─────────────────────────────────────────────────────────────────────────────

class _StepBar extends StatelessWidget {
  const _StepBar({required this.current, required this.total});

  /// current: 1-indexed step that is IN PROGRESS (current and before = filled)
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: List.generate(total, (i) {
          final filled = i < current;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(left: i == 0 ? 0 : 4),
              height: 3,
              decoration: BoxDecoration(
                color: filled ? AppColors.primaryO400 : AppColors.neutralN100,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared reminder banner (can't take photo right now)
// ─────────────────────────────────────────────────────────────────────────────

class _ReminderBanner extends StatelessWidget {
  const _ReminderBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.neutralN50,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome, size: 20, color: AppColors.navy),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.navy,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Set a reminder',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 13,
                    color: AppColors.primaryO400,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryO400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared info list tile row
// ─────────────────────────────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label, this.divider = true});
  final IconData icon;
  final String label;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 22, color: AppColors.navy),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyRegular.copyWith(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        if (divider)
          const Divider(color: AppColors.neutralN100, height: 1, indent: 20),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen 1 — Personal Information (no step bar)
// ─────────────────────────────────────────────────────────────────────────────

class _PersonalInfoScreen extends StatelessWidget {
  const _PersonalInfoScreen({required this.onNext, required this.onBack});
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return KBaseScreenMultiLayout(
      showStatusBar: true,
      appBar: AppNavBar.logo(
        onBack: onBack,
        backgroundColor: AppColors.white,
      ),
      hasStickyFooter: true,
      footer: AppStickyBottomBar(
        primaryLabel: 'Submit',
        primaryVariant: AppButtonVariant.primary,
        onPrimary: onNext,
        backgroundColor: AppColors.white,
      ),
      content: [
        const SizedBox(height: AppSpacing.lg),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Text(
            'Personal information',
            style: AppTextStyles.heading2,
          ),
        ),

        const SizedBox(height: AppSpacing.xs),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Text(
            'Please confirm the additional details',
            style: AppTextStyles.bodyRegular.copyWith(
              color: AppColors.neutralN500,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: AppTextField(
            label: 'Birthday',
            initialValue: 'January 1, 1990',
            readOnly: true,
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Text(
            'You must be 18 years old or older be eligible for Yendo',
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 12,
              color: AppColors.neutralN500,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen 2 — Vehicle Photos educational (step 1 of 4)
// ─────────────────────────────────────────────────────────────────────────────

class _VehiclePhotoEdScreen extends StatelessWidget {
  const _VehiclePhotoEdScreen({required this.onNext, required this.onBack});
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return KBaseScreenMultiLayout(
      showStatusBar: true,
      contentPadding: 0,
      appBar: AppNavBar.logo(
        onBack: onBack,
        backgroundColor: AppColors.white,
      ),
      hasStickyFooter: true,
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBar(current: 1, total: 4),
          _ReminderBanner(
            message: "Not with your car or can't take a clear photos of your car right now?",
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: AppButton(
              label: 'Take Photo',
              variant: AppButtonVariant.primary,
              onPressed: onNext,
              fullWidth: true,
            ),
          ),
        ],
      ),
      content: [
        const SizedBox(height: AppSpacing.lg),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Text('Vehicle photos', style: AppTextStyles.heading2),
        ),

        const SizedBox(height: AppSpacing.xs),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Text(
            'We need photos of the exterior of your vehicle to verify it.',
            style: AppTextStyles.bodyRegular.copyWith(color: AppColors.neutralN500),
          ),
        ),

        const SizedBox(height: AppSpacing.xs),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Text(
            'See example',
            style: AppTextStyles.bodyRegular.copyWith(
              color: AppColors.primaryO400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        const _InfoTile(icon: Icons.photo_camera_outlined, label: 'Wipe your camera lens clean'),
        const _InfoTile(icon: Icons.wb_sunny_outlined, label: 'Ensure vehicle is in a well lit environment'),
        const _InfoTile(icon: Icons.image_outlined, label: 'Ensure photos are clear and not blurry', divider: false),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen 3 — Front of Title Photo (step 2 of 4)
// ─────────────────────────────────────────────────────────────────────────────

class _FrontTitleScreen extends StatelessWidget {
  const _FrontTitleScreen({required this.onNext, required this.onBack});
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return _TitlePhotoScreen(
      title: 'Front of title photo',
      subtitle: 'Please upload the front of your vehicle title',
      step: 2,
      onNext: onNext,
      onBack: onBack,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen 4 — Back of Title Photo (step 3 of 4)
// ─────────────────────────────────────────────────────────────────────────────

class _BackTitleScreen extends StatelessWidget {
  const _BackTitleScreen({required this.onNext, required this.onBack});
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return _TitlePhotoScreen(
      title: 'Back of title photo',
      subtitle: 'Please upload back of your vehicle title',
      step: 3,
      onNext: onNext,
      onBack: onBack,
    );
  }
}

/// Shared template for front/back title screens
class _TitlePhotoScreen extends StatelessWidget {
  const _TitlePhotoScreen({
    required this.title,
    required this.subtitle,
    required this.step,
    required this.onNext,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final int step;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return KBaseScreenMultiLayout(
      showStatusBar: true,
      contentPadding: 0,
      appBar: AppNavBar.logo(
        onBack: onBack,
        backgroundColor: AppColors.white,
      ),
      hasStickyFooter: true,
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBar(current: step, total: 4),
          _ReminderBanner(message: "Can't take a clear photo of your title right now?"),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: AppButton(
              label: 'Take Photo',
              variant: AppButtonVariant.primary,
              onPressed: onNext,
              fullWidth: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: AppButton(
              label: "I don't have my title",
              variant: AppButtonVariant.tertiary,
              onPressed: () {},
              fullWidth: true,
            ),
          ),
        ],
      ),
      content: [
        const SizedBox(height: AppSpacing.lg),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Text(title, style: AppTextStyles.heading2),
        ),

        const SizedBox(height: AppSpacing.xs),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Text(
            subtitle,
            style: AppTextStyles.bodyRegular.copyWith(color: AppColors.neutralN500),
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        const _InfoTile(icon: Icons.image_outlined, label: 'Take clear and crisp photos'),
        const _InfoTile(icon: Icons.text_fields, label: 'Make sure text is clear and easy to read'),
        const _InfoTile(icon: Icons.photo_camera_outlined, label: 'Wipe your camera lens clean', divider: false),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen 5 — Vehicle Photos grid / submitted (step 4 of 4)
// ─────────────────────────────────────────────────────────────────────────────

class _VehiclePhotoGridScreen extends StatelessWidget {
  const _VehiclePhotoGridScreen({required this.onBack});
  final VoidCallback onBack;

  static const _photoColors = [
    Color(0xFF1A1A2E),
    Color(0xFF16213E),
    Color(0xFF0F3460),
    Color(0xFF1A1A2E),
    Color(0xFF2A2A4A),
  ];

  static const _photoLabels = ['', 'Front', '', '', ''];

  @override
  Widget build(BuildContext context) {
    return KBaseScreenMultiLayout(
      showStatusBar: true,
      contentPadding: 0,
      appBar: AppNavBar.logo(
        onBack: onBack,
        backgroundColor: AppColors.white,
      ),
      hasStickyFooter: true,
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBar(current: 4, total: 4),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Row(
              children: [
                const Icon(Icons.signal_cellular_alt, size: 16, color: AppColors.neutralN500),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ensure your network is strong before submitting photos',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 12,
                      color: AppColors.neutralN500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: AppButton(
              label: 'Submit photos',
              variant: AppButtonVariant.primary,
              onPressed: () {},
              fullWidth: true,
            ),
          ),
        ],
      ),
      content: [
        const SizedBox(height: AppSpacing.lg),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Text('Vehicle photos', style: AppTextStyles.heading2),
        ),

        const SizedBox(height: AppSpacing.xl),

        // Photo grid (5 photos: 2-column layout, last row is single)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
          child: Column(
            children: [
              Row(
                children: [
                  _PhotoTile(color: _photoColors[0], label: _photoLabels[0]),
                  const SizedBox(width: 4),
                  _PhotoTile(color: _photoColors[1], label: _photoLabels[1]),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _PhotoTile(color: _photoColors[2], label: _photoLabels[2]),
                  const SizedBox(width: 4),
                  _PhotoTile(color: _photoColors[3], label: _photoLabels[3]),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _PhotoTile(color: _photoColors[4], label: _photoLabels[4]),
                  const SizedBox(width: 4),
                  Expanded(child: SizedBox()), // empty slot
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.35,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
            if (label.isNotEmpty)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
