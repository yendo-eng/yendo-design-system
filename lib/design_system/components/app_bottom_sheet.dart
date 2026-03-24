import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';
import 'app_button.dart';

/// Yendo Design System — AppBottomSheet
///
/// A flexible modal bottom sheet with optional illustration,
/// title, description, list items, and a CTA button.
///
/// Show it using the helper function:
///   showAppBottomSheet(
///     context: context,
///     title: 'Title here',
///     description: 'Your description text goes here.',
///     buttonLabel: 'Confirm',
///     onButtonPressed: () {},
///   );
///
/// With list items:
///   showAppBottomSheet(
///     context: context,
///     title: 'What you need',
///     listItems: [
///       AppBottomSheetItem(icon: Icons.camera_alt, label: 'Photo ID', description: 'Front and back'),
///       AppBottomSheetItem(icon: Icons.directions_car, label: 'Vehicle info', description: 'Make, model, year'),
///     ],
///     buttonLabel: 'Got it',
///     onButtonPressed: () {},
///   );

// ── Data model for list items ──────────────────────────────

class AppBottomSheetItem {
  const AppBottomSheetItem({
    required this.label,
    this.description,
    this.icon,
    this.iconWidget,
  });

  final String label;
  final String? description;
  final IconData? icon;
  final Widget? iconWidget;
}

// ── Helper function to show the bottom sheet ───────────────

Future<void> showAppBottomSheet({
  required BuildContext context,
  String? title,
  String? description,
  String? buttonLabel,
  VoidCallback? onButtonPressed,
  Widget? illustration,
  Widget? child,
  List<AppBottomSheetItem>? listItems,
  bool showCloseButton = true,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (_) => AppBottomSheet(
      title: title,
      description: description,
      buttonLabel: buttonLabel,
      onButtonPressed: onButtonPressed,
      illustration: illustration,
      child: child,
      listItems: listItems,
      showCloseButton: showCloseButton,
    ),
  );
}

// ── Widget ─────────────────────────────────────────────────

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    this.title,
    this.description,
    this.buttonLabel,
    this.onButtonPressed,
    this.illustration,
    this.child,
    this.listItems,
    this.showCloseButton = true,
  });

  final String? title;
  final String? description;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;
  final Widget? illustration;
  /// Optional custom content rendered below description
  final Widget? child;
  final List<AppBottomSheetItem>? listItems;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 84,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Close button ─────────────────────────────────
          if (showCloseButton)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.neutralN100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ),
            ),

          // ── Illustration ─────────────────────────────────
          if (illustration != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: illustration,
                ),
              ),
            ),

          // ── Title ─────────────────────────────────────────
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title!,
                  style: AppTextStyles.heading3.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    height: 1.33,
                  ),
                ),
              ),
            ),

          // ── Description ──────────────────────────────────
          if (description != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Text(
                description!,
                style: AppTextStyles.bodyRegular.copyWith(
                  color: AppColors.neutralN500,
                  height: 1.5,
                ),
              ),
            ),

          // ── Custom child content ──────────────────────────
          if (child != null) child!,

          // ── List items ────────────────────────────────────
          if (listItems != null && listItems!.isNotEmpty)
            Column(
              children: listItems!.map((item) {
                final isLast = listItems!.last == item;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Row(
                        children: [
                          // Icon area
                          SizedBox(
                            width: 64,
                            height: 64,
                            child: Center(
                              child: item.iconWidget ??
                                  Icon(
                                    item.icon ?? Icons.circle,
                                    size: 24,
                                    color: AppColors.navy,
                                  ),
                            ),
                          ),
                          // Text
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.label,
                                    style: AppTextStyles.bodyRegular.copyWith(
                                      fontWeight: FontWeight.w500,
                                      height: 1.25,
                                    ),
                                  ),
                                  if (item.description != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      item.description!,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.neutralN500,
                                        height: 1.43,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Divider (not on last item)
                    if (!isLast)
                      const Padding(
                        padding: EdgeInsets.only(left: 64),
                        child: Divider(height: 1, thickness: 1, color: AppColors.neutralN100),
                      ),
                  ],
                );
              }).toList(),
            ),

          // ── Divider before button ─────────────────────────
          if (buttonLabel != null)
            const Divider(height: 1, thickness: 1, color: AppColors.neutralN100),

          // ── Button ────────────────────────────────────────
          if (buttonLabel != null)
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: AppButton(
                label: buttonLabel!,
                variant: AppButtonVariant.alternate,
                onPressed: onButtonPressed,
                isFullWidth: true,
              ),
            ),

          // ── Safe area bottom space ────────────────────────
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
