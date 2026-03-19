import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';
import 'app_button.dart';

/// Yendo Design System — AppCard
///
/// A loan summary card with an optional past-due warning banner.
///
/// Example usage:
///   AppCard(
///     amountLabel: 'Amount due',
///     amount: '\$234.78',
///     statusText: '3 days past due',
///     isPastDue: true,
///     footerText: 'Remaining loan balance: \$12,418',
///     buttonLabel: 'Manage loan',
///     onButtonPressed: () {},
///   )

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.amount,
    required this.buttonLabel,
    required this.onButtonPressed,
    this.amountLabel = 'Amount due',
    this.statusText,
    this.isPastDue = false,
    this.footerText,
  });

  /// The large dollar amount shown on the card e.g. '\$234.78'
  final String amount;

  /// Label above the amount e.g. 'Amount due'
  final String amountLabel;

  /// Status text shown below the amount e.g. 'X days past due'
  final String? statusText;

  /// When true shows the pink warning banner at the top
  final bool isPastDue;

  /// Small text at the bottom e.g. 'Remaining loan balance: \$12,418'
  final String? footerText;

  /// Text on the CTA button
  final String buttonLabel;

  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Warning banner (only when past due) ───────────
        if (isPastDue)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFFFEBE6), // Red/R-100
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_rounded,
                  color: Color(0xFFDE350B),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your payment is past due',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 1.33,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // ── Card body ─────────────────────────────────────
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: isPastDue ? Radius.zero : const Radius.circular(8),
              topRight: isPastDue ? Radius.zero : const Radius.circular(8),
              bottomLeft: const Radius.circular(8),
              bottomRight: const Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Amount + button row ──────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Stack vertically on very narrow screens (< 280px content)
                    final isNarrow = constraints.maxWidth < 280;
                    final amountSection = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          amountLabel,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 12,
                            height: 1.33,
                            color: AppColors.neutralN500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          amount,
                          style: AppTextStyles.heading3.copyWith(
                            fontSize: constraints.maxWidth < 320 ? 20 : 24,
                            fontWeight: FontWeight.w700,
                            height: 1.33,
                          ),
                        ),
                        if (statusText != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            statusText!,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 12,
                              height: 1.33,
                              color: const Color(0xFFDE350B),
                            ),
                          ),
                        ],
                      ],
                    );
                    final button = AppButton(
                      label: buttonLabel,
                      onPressed: onButtonPressed,
                      size: constraints.maxWidth < 320
                          ? AppButtonSize.small
                          : AppButtonSize.defaultSize,
                    );
                    if (isNarrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [amountSection, const SizedBox(height: 12), button],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: amountSection),
                        const SizedBox(width: 12),
                        button,
                      ],
                    );
                  },
                ),
              ),

              // ── Divider ─────────────────────────────────
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 16),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.neutralN75,
                ),
              ),

              // ── Footer text ─────────────────────────────
              if (footerText != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Text(
                    footerText!,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 12,
                      height: 1.33,
                      color: const Color(0xFF2E4457), // Content/Secondary
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
