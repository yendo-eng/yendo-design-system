import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';

/// Yendo Design System — AppButton
///
/// Variants : primary | alternate | tertiary | link
/// Sizes    : defaultSize | small
/// States   : active, hover, pressed, disabled  (handled automatically)
///
/// Example usage:
///   AppButton(label: 'Get started', onPressed: () {})
///   AppButton(label: 'Learn more', variant: AppButtonVariant.alternate, onPressed: () {})
///   AppButton(label: 'Cancel', variant: AppButtonVariant.tertiary, onPressed: () {})
///   AppButton(label: 'View details', variant: AppButtonVariant.link, onPressed: () {})

enum AppButtonVariant { primary, alternate, tertiary, link }

enum AppButtonSize { defaultSize, small }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.defaultSize,
    this.icon,
    this.showIcon = false,
    this.isFullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final Widget? icon;
  final bool showIcon;
  final bool isFullWidth;

  bool get _isDisabled => onPressed == null;
  bool get _isSmall => size == AppButtonSize.small;

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.link) {
      return _buildLinkButton();
    }
    return _buildStandardButton();
  }

  // ── Standard button (primary / alternate / tertiary) ──

  Widget _buildStandardButton() {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: _isDisabled
          ? _buildButtonContent(isPressed: false)
          : _ButtonPressDetector(
              onPressed: onPressed!,
              builder: (isPressed) => _buildButtonContent(isPressed: isPressed),
            ),
    );
  }

  Widget _buildButtonContent({required bool isPressed}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: _isSmall ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor(isPressed),
        borderRadius: BorderRadius.circular(99),
        border: variant == AppButtonVariant.tertiary
            ? Border.all(
                color: _isDisabled
                    ? AppColors.neutralN200
                    : isPressed
                        ? AppColors.neutralN200
                        : AppColors.navy,
                width: 1.5,
              )
            : null,
      ),
      child: Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showIcon && icon != null) ...[
            icon!,
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: AppTextStyles.buttonDefault.copyWith(
              color: _textColor(),
              fontWeight: variant == AppButtonVariant.tertiary
                  ? FontWeight.w500
                  : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Color _backgroundColor(bool isPressed) {
    if (_isDisabled) return AppColors.neutralN100;

    switch (variant) {
      case AppButtonVariant.primary:
        if (isPressed) return AppColors.primaryO500;
        return AppColors.primaryO400;
      case AppButtonVariant.alternate:
        if (isPressed) return AppColors.navy.withValues(alpha: 0.85);
        return AppColors.navy;
      case AppButtonVariant.tertiary:
        if (isPressed) return AppColors.primaryO400.withValues(alpha: 0.06);
        return Colors.transparent;
      case AppButtonVariant.link:
        return Colors.transparent;
    }
  }

  Color _textColor() {
    if (_isDisabled) return AppColors.contentDisabled;

    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.alternate:
        return AppColors.white;
      case AppButtonVariant.tertiary:
      case AppButtonVariant.link:
        return AppColors.navy;
    }
  }

  // ── Link button ───────────────────────────────────────

  Widget _buildLinkButton() {
    final textStyle = _isSmall
        ? AppTextStyles.linkSmall
        : AppTextStyles.linkLarge;

    final color = _isDisabled ? AppColors.contentDisabled : AppColors.navy;

    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && icon != null) ...[
            icon!,
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: textStyle.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Internal helper for press state ───────────────────────

class _ButtonPressDetector extends StatefulWidget {
  const _ButtonPressDetector({
    required this.onPressed,
    required this.builder,
  });

  final VoidCallback onPressed;
  final Widget Function(bool isPressed) builder;

  @override
  State<_ButtonPressDetector> createState() => _ButtonPressDetectorState();
}

class _ButtonPressDetectorState extends State<_ButtonPressDetector> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: widget.builder(_isPressed),
    );
  }
}
