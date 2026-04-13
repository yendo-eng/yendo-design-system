import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    this.showLogo = false,
    this.backgroundColor = AppColors.white,
    this.height = 50,
  });

  /// Named constructor for the logo variant.
  ///
  /// Without [onBack]: logo sits flush left (brand header — first screen).
  /// With [onBack]:    logo is centred, back button on the left (mid-funnel).
  const AppNavBar.logo({
    super.key,
    this.onBack,
    this.onClose,
    this.backgroundColor = Colors.transparent,
    this.height = 50,
  })  : title = null,
        showBackButton = false,
        showCloseOnly = false,
        showLogo = true;

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

  /// When true, shows the Yendo orange logo on the left instead of a back button.
  final bool showLogo;

  final Color backgroundColor;
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // ── Left ────────────────────────────────────────
          SizedBox(
            width: 40,
            child: !showCloseOnly && showBackButton && onBack != null
                ? AppBackButton(onPressed: onBack)
                : const SizedBox.shrink(),
          ),

          // ── Center ───────────────────────────────────────
          Expanded(
            child: showLogo
                // Logo centred (works for both back+logo and logo-only)
                ? Center(
                    child: SvgPicture.asset(
                      'assets/svgs/logos/logo_orange.svg',
                      height: 18,
                    ),
                  )
                : title != null
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

          // ── Right ────────────────────────────────────────
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

/// Standalone back button — chevron icon, no background circle.
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
      child: const SizedBox(
        width: 36,
        height: 36,
        child: Icon(
          Icons.chevron_left_rounded,
          size: 26,
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
