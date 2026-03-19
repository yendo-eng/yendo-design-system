import 'package:flutter/material.dart';
import '../colors.dart';

/// Yendo Design System — AppProgressBar
///
/// A thin step-based progress bar for multi-step application funnels.
/// Shows how far the user is through a flow.
///
/// Example usage:
///   AppProgressBar(currentStep: 2, totalSteps: 5)
///
/// As a percentage (0.0 to 1.0):
///   AppProgressBar.percentage(value: 0.4)

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.height = 4,
    this.activeColor = AppColors.primaryO400,
    this.inactiveColor = AppColors.neutralN100,
    this.animated = true,
  })  : assert(currentStep >= 0),
        assert(totalSteps > 0),
        _value = null;

  const AppProgressBar.percentage({
    super.key,
    required double value,
    this.height = 4,
    this.activeColor = AppColors.primaryO400,
    this.inactiveColor = AppColors.neutralN100,
    this.animated = true,
  })  : _value = value,
        currentStep = 0,
        totalSteps = 1;

  final int currentStep;
  final int totalSteps;
  final double height;
  final Color activeColor;
  final Color inactiveColor;
  final bool animated;
  final double? _value;

  double get _progress =>
      _value ?? (totalSteps == 0 ? 0.0 : (currentStep / totalSteps).clamp(0.0, 1.0));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          return Stack(
            children: [
              // ── Background track ──────────────────────────
              Container(
                width: totalWidth,
                height: height,
                color: inactiveColor,
              ),
              // ── Active fill ───────────────────────────────
              animated
                  ? AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: totalWidth * _progress,
                      height: height,
                      color: activeColor,
                    )
                  : Container(
                      width: totalWidth * _progress,
                      height: height,
                      color: activeColor,
                    ),
            ],
          );
        },
      ),
    );
  }
}

/// A segmented step indicator — shows individual pill segments.
///
/// Example usage:
///   AppStepIndicator(currentStep: 2, totalSteps: 5)
class AppStepIndicator extends StatelessWidget {
  const AppStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.height = 4,
    this.gap = 4,
    this.activeColor = AppColors.primaryO400,
    this.inactiveColor = AppColors.neutralN100,
    this.completedColor = AppColors.primaryO400,
  });

  final int currentStep;
  final int totalSteps;
  final double height;
  final double gap;
  final Color activeColor;
  final Color inactiveColor;
  final Color completedColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isCompleted = index < currentStep;
          final isActive = index == currentStep - 1;
          final color = isCompleted || isActive ? completedColor : inactiveColor;

          return Expanded(
            child: Container(
              height: height,
              margin: EdgeInsets.only(right: index < totalSteps - 1 ? gap : 0),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
