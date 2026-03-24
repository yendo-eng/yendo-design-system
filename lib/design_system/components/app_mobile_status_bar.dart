import 'dart:async';
import 'package:flutter/material.dart';
import '../colors.dart';

/// Yendo Design System — AppMobileStatusBar
///
/// A simulated iOS-style mobile status bar showing the current time,
/// signal strength, Wi-Fi, and battery level.
///
/// Designed for use in prototypes and design system demos where the
/// native system status bar is not visible (web, simulator chrome, desktop).
///
/// Usage — pass [showStatusBar: true] to KBaseScreenMultiLayout, or
/// render directly inside any Column at the top of a screen.

class AppMobileStatusBar extends StatefulWidget {
  const AppMobileStatusBar({
    super.key,
    this.backgroundColor,

    /// Icon/text color. Defaults to [AppColors.navy].
    this.foregroundColor,
  });

  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  State<AppMobileStatusBar> createState() => _AppMobileStatusBarState();
}

class _AppMobileStatusBarState extends State<AppMobileStatusBar> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    // Refresh every 30 s so time stays current during a demo session.
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _timeString {
    var hour = _now.hour % 12;
    if (hour == 0) hour = 12;
    final min = _now.minute.toString().padLeft(2, '0');
    return '$hour:$min';
  }

  @override
  Widget build(BuildContext context) {
    final fg = widget.foregroundColor ?? AppColors.navy;

    return Container(
      height: 44,
      color: widget.backgroundColor ?? Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Time ────────────────────────────────────────────
          Text(
            _timeString,
            style: TextStyle(
              fontFamily: 'PPNeueMontreal',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: fg,
              height: 1,
              letterSpacing: 0.2,
            ),
          ),

          // ── Indicators ──────────────────────────────────────
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _SignalBars(color: fg),
              const SizedBox(width: 6),
              Icon(Icons.wifi_rounded, size: 15, color: fg),
              const SizedBox(width: 6),
              _BatteryIcon(color: fg),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Signal bars ────────────────────────────────────────────

class _SignalBars extends StatelessWidget {
  const _SignalBars({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    // 4 bars of increasing height — full signal
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (int i = 0; i < 4; i++)
          Padding(
            padding: EdgeInsets.only(right: i < 3 ? 1.5 : 0),
            child: Container(
              width: 3,
              height: 4.5 + (i * 2.5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Battery icon ────────────────────────────────────────────

class _BatteryIcon extends StatelessWidget {
  const _BatteryIcon({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 12,
      child: CustomPaint(
        painter: _BatteryPainter(color: color, fillFraction: 0.75),
      ),
    );
  }
}

class _BatteryPainter extends CustomPainter {
  const _BatteryPainter({required this.color, required this.fillFraction});

  final Color color;
  final double fillFraction;

  @override
  void paint(Canvas canvas, Size size) {
    final bodyWidth = size.width - 3.5;

    // Outline
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, bodyWidth, size.height),
        const Radius.circular(2.5),
      ),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Nub
    canvas.drawRect(
      Rect.fromLTWH(
        bodyWidth,
        size.height * 0.3,
        3.5,
        size.height * 0.4,
      ),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );

    // Fill
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2, 2, (bodyWidth - 4) * fillFraction, size.height - 4),
        const Radius.circular(1.5),
      ),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _BatteryPainter old) =>
      old.fillFraction != fillFraction || old.color != color;
}
