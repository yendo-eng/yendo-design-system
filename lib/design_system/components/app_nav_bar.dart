import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';

/// Yendo Design System — AppNavBar
///
/// A top navigation bar used across funnel and app screens.
/// Supports a back button, centered title, and optional right action (e.g. close X).
///
/// Variants:
///   - Back only (default)
///   - Back + Title
///   - Back + Title + Close
///   - Close only (first funnel screen)
///
/// Example usage:
///   AppNavBar(onBack: () => Navigator.pop(context))
///   AppNavBar(title: 'Your info', onBack: () {}, onClose: () {})
///   AppNavBar(showCloseOnly: true, onClose: () {})

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  const AppNavBar({
    super.key,
    this.title,
    this.onBack,
    this.onClose,
    this.showBackButton = true,
    this.showCloseOnly = false,
    this.backgroundColor = AppColors.white,
  });

  /// Centered title text
  final String? title;

  /// Callback for the back button. If null, back button is hidden.
  final VoidCallback? onBack;

  /// Callback for the close (X) button in the top right.
  final VoidCallback? onClose;

  /// Whether to show the back button (default true)
  final bool showBackButton;

  /// When true, hides back button and shows only a close button on the right.
  /// Use on the very first screen of a funnel.
  final bool showCloseOnly;

  final Color backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // ── Left: Back button or spacer ─────────────────
          SizedBox(
            width: 40,
            child: (!showCloseOnly && showBackButton && onBack != null)
                ? AppBackButton(onPressed: onBack!)
                : const SizedBox.shrink(),
          ),

          // ── Center: Title ────────────────────────────────
          Expanded(
            child: title != null
                ? Center(
                    child: Text(
                      title!,
                      style: AppTextStyles.bodyRegular.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // ── Right: Close button or spacer ────────────────
          SizedBox(
            width: 40,
            child: onClose != null
                ? _NavCloseButton(onPressed: onClose!)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ── Back Button ────────────────────────────────────────────

/// Standalone back button — circle with chevron left.
/// Can be used inside AppNavBar or anywhere on its own.
class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.neutralN75,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.chevron_left_rounded,
          size: 24,
          color: AppColors.navy,
        ),
      ),
    );
  }
}

// ── Close Button (internal) ────────────────────────────────

class _NavCloseButton extends StatelessWidget {
  const _NavCloseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: AppColors.neutralN100,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close_rounded,
          size: 20,
          color: AppColors.navy,
        ),
      ),
    );
  }
}
