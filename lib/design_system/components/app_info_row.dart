import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';

/// Yendo Design System — AppInfoRow
///
/// A label + value row used on review/confirm screens and detail pages.
/// Supports an optional divider, icon, and badge.
///
/// Example usage (single row):
///   AppInfoRow(label: 'Monthly payment', value: '\$234.78')
///
/// Example usage (list of rows):
///   AppInfoSection(
///     title: 'Loan details',
///     rows: [
///       AppInfoRow(label: 'Amount', value: '\$12,000'),
///       AppInfoRow(label: 'Term', value: '36 months'),
///       AppInfoRow(label: 'APR', value: '12.5%'),
///     ],
///   )

class AppInfoRow extends StatelessWidget {
  const AppInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.showDivider = true,
    this.leadingIcon,
    this.trailingWidget,
    this.onTap,
    this.valueBadgeColor,
  });

  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  /// Show a divider below this row (default true)
  final bool showDivider;

  /// Optional leading icon
  final IconData? leadingIcon;

  /// Optional trailing widget (replaces value text)
  final Widget? trailingWidget;

  final VoidCallback? onTap;

  /// If set, wraps the value in a colored badge
  final Color? valueBadgeColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Leading icon ──────────────────────────
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: 20, color: AppColors.neutralN500),
                  const SizedBox(width: 12),
                ],

                // ── Label ─────────────────────────────────
                Expanded(
                  child: Text(
                    label,
                    style: labelStyle ??
                        AppTextStyles.bodyRegular.copyWith(
                          color: AppColors.neutralN500,
                          fontSize: 14,
                        ),
                  ),
                ),

                const SizedBox(width: 12),

                // ── Value or trailing ─────────────────────
                trailingWidget ??
                    (valueBadgeColor != null
                        ? _ValueBadge(value: value, color: valueBadgeColor!)
                        : Text(
                            value,
                            style: valueStyle ??
                                AppTextStyles.bodyRegular.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                            textAlign: TextAlign.right,
                          )),

                // ── Arrow if tappable ─────────────────────
                if (onTap != null) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: AppColors.neutralN500,
                  ),
                ],
              ],
            ),
          ),
        ),

        // ── Divider ───────────────────────────────────────
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: AppColors.neutralN100),
      ],
    );
  }
}

// ── Value Badge ────────────────────────────────────────────

class _ValueBadge extends StatelessWidget {
  const _ValueBadge({required this.value, required this.color});

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        value,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
          height: 1.33,
        ),
      ),
    );
  }
}

// ── AppInfoSection ─────────────────────────────────────────

/// A card-like container grouping multiple AppInfoRows with an optional title.
class AppInfoSection extends StatelessWidget {
  const AppInfoSection({
    super.key,
    required this.rows,
    this.title,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final List<AppInfoRow> rows;
  final String? title;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.5,
              color: AppColors.neutralN500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: padding,
            child: Column(
              children: [
                for (int i = 0; i < rows.length; i++)
                  AppInfoRow(
                    label: rows[i].label,
                    value: rows[i].value,
                    labelStyle: rows[i].labelStyle,
                    valueStyle: rows[i].valueStyle,
                    showDivider: i < rows.length - 1,
                    leadingIcon: rows[i].leadingIcon,
                    trailingWidget: rows[i].trailingWidget,
                    onTap: rows[i].onTap,
                    valueBadgeColor: rows[i].valueBadgeColor,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
