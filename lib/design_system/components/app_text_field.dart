import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../colors.dart';
import '../typography.dart';

/// Yendo Design System — AppTextField
///
/// A styled text input field for forms and application funnels.
/// Supports labels, hints, error states, helper text, and prefix/suffix.
///
/// Example usage:
///   AppTextField(label: 'First name', hint: 'e.g. Jane')
///   AppTextField(label: 'Phone number', keyboardType: TextInputType.phone)
///   AppTextField(label: 'SSN', obscureText: true)
///   AppTextField(label: 'Amount', prefix: '\$', error: 'Required field')

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.error,
    this.prefix,
    this.suffix,
    this.suffixIcon,
    this.prefixIcon,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.autofocus = false,
  });

  final String? label;
  final String? hint;
  final String? helperText;
  final String? error;
  final String? prefix;
  final String? suffix;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final bool autofocus;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  bool get _hasError => widget.error != null && widget.error!.isNotEmpty;

  Color get _borderColor {
    if (!widget.enabled) return AppColors.neutralN200;
    if (_hasError) return AppColors.red400;
    if (_isFocused) return AppColors.navy;
    return AppColors.neutralN200;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label ─────────────────────────────────────────
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: widget.enabled ? AppColors.navy : AppColors.contentDisabled,
            ),
          ),
          const SizedBox(height: 6),
        ],

        // ── Input field ───────────────────────────────────
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: widget.enabled ? AppColors.white : AppColors.neutralN75,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _borderColor, width: _isFocused ? 1.5 : 1),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            onTap: widget.onTap,
            obscureText: _obscureText,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            maxLength: widget.maxLength,
            autofocus: widget.autofocus,
            style: AppTextStyles.bodyRegular.copyWith(
              color: widget.enabled ? AppColors.navy : AppColors.contentDisabled,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.bodyRegular.copyWith(
                color: AppColors.neutralN500,
              ),
              prefixText: widget.prefix,
              prefixStyle: AppTextStyles.bodyRegular,
              suffixText: widget.suffix,
              suffixStyle: AppTextStyles.bodyRegular.copyWith(
                color: AppColors.neutralN500,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: widget.prefixIcon,
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(),
              suffixIcon: widget.obscureText
                  ? GestureDetector(
                      onTap: () => setState(() => _obscureText = !_obscureText),
                      child: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.neutralN500,
                      ),
                    )
                  : widget.suffixIcon,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
              counterText: '',
            ),
          ),
        ),

        // ── Helper or error text ───────────────────────────
        if (_hasError || widget.helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            _hasError ? widget.error! : widget.helperText!,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 12,
              height: 1.33,
              color: _hasError ? AppColors.red400 : AppColors.neutralN500,
            ),
          ),
        ],
      ],
    );
  }
}
