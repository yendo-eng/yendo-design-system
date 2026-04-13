import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../colors.dart';

// ── Yendo Confetti ──────────────────────────────────────────────────────────
//
// Cannon-burst confetti: two cannons fire simultaneously from the top-left
// and top-right corners. Particles arc inward across the screen under gravity
// and naturally exit off the bottom and sides.
//
// Usage:
//   YendoConfetti.wrap(child: YourScreen())

class YendoConfetti extends StatefulWidget {
  const YendoConfetti({super.key, this.particleCount = 80});

  final int particleCount;

  static Widget wrap({
    required Widget child,
    int particleCount = 80,
    Color backgroundColor = const Color(0xFFF5F7FA),
  }) {
    return Stack(
      children: [
        Positioned.fill(child: ColoredBox(color: backgroundColor)),
        YendoConfetti(particleCount: particleCount),
        child,
      ],
    );
  }

  @override
  State<YendoConfetti> createState() => _YendoConfettiState();
}

class _YendoConfettiState extends State<YendoConfetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final List<_Particle> _particles;
  final math.Random _rng = math.Random();

  static const _colors = [
    AppColors.primaryO400,
    AppColors.primaryO300,
    AppColors.green400,
    AppColors.yellow400,
    Color(0xFF1A2B5C),
    AppColors.neutralN200,
  ];

  static const double _totalSec = 5.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_totalSec * 1000).round()),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _particles = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = MediaQuery.of(context).size;
      _buildParticles(size);
      setState(() {});
      _controller.forward();
    });
  }

  void _buildParticles(Size size) {
    _particles.clear();
    final half = widget.particleCount ~/ 2;

    for (int i = 0; i < widget.particleCount; i++) {
      final isLeft = i < half;

      // Cannon mouth: tight cluster near each top corner
      final ox = isLeft
          ? _rng.nextDouble() * 16
          : size.width - _rng.nextDouble() * 16;
      final oy = _rng.nextDouble() * 20;

      // Speed: faster particles arc further across the screen
      final speed = 220.0 + _rng.nextDouble() * 160;

      // Angle:
      //   Left cannon  — shoot rightward, spread from ~-25° (slightly up)
      //                  to ~+55° (downward), centred on ~+15°
      //   Right cannon — mirror image (shoot leftward)
      double angle;
      if (isLeft) {
        // radians: 0 = right, positive = down in Flutter
        angle = (-0.44 + _rng.nextDouble() * 1.38); // ~-25° to +55°
      } else {
        angle = math.pi - (-0.44 + _rng.nextDouble() * 1.38);
      }

      _particles.add(_Particle(
        origin: Offset(ox, oy),
        vx: speed * math.cos(angle),
        vy: speed * math.sin(angle),
        color: _colors[_rng.nextInt(_colors.length)],
        shape: _Shape.values[_rng.nextInt(_Shape.values.length)],
        size: _rng.nextDouble() * 5 + 4,
        rotationSpeed: (_rng.nextDouble() - 0.5) * 12,
        // Very short stagger — feels like a simultaneous burst, not rain
        phaseOffset: _rng.nextDouble() * 0.06,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, _) => CustomPaint(
            painter: _ConfettiPainter(
              particles: _particles,
              progress: _animation.value,
              totalSec: _totalSec,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Particle model ───────────────────────────────────────────────────────────

enum _Shape { dot, ribbon, square }

class _Particle {
  const _Particle({
    required this.origin,
    required this.vx,
    required this.vy,
    required this.color,
    required this.shape,
    required this.size,
    required this.rotationSpeed,
    required this.phaseOffset,
  });

  final Offset origin;
  final double vx;
  final double vy;
  final Color color;
  final _Shape shape;
  final double size;
  final double rotationSpeed;
  final double phaseOffset;
}

// ── Painter ──────────────────────────────────────────────────────────────────

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({
    required this.particles,
    required this.progress,
    required this.totalSec,
  });

  final List<_Particle> particles;
  final double progress;
  final double totalSec;

  // Gravity — strong enough to produce a visible arc within the screen height
  static const double _gravity = 260;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final dt = math.max(0.0, (progress - p.phaseOffset) * totalSec);
      if (dt <= 0) continue;

      // Projectile motion: x is linear, y accelerates under gravity
      final x = p.origin.dx + p.vx * dt;
      final y = p.origin.dy + p.vy * dt + 0.5 * _gravity * dt * dt;

      // Fade out in the last 30% of each particle's lifespan
      final maxDt = (1.0 - p.phaseOffset) * totalSec;
      final lifeProgress = dt / maxDt;
      final opacity = lifeProgress < 0.70
          ? 1.0
          : (1.0 - (lifeProgress - 0.70) / 0.30).clamp(0.0, 1.0);

      if (opacity <= 0) continue;

      paint.color = p.color.withValues(alpha: opacity);

      final rotation = p.rotationSpeed * dt;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      switch (p.shape) {
        case _Shape.dot:
          canvas.drawCircle(Offset.zero, p.size / 2, paint);
        case _Shape.ribbon:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset.zero,
                width: p.size * 0.4,
                height: p.size * 2.6,
              ),
              const Radius.circular(1),
            ),
            paint,
          );
        case _Shape.square:
          final half = p.size * 0.45;
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: half * 2,
              height: half * 2,
            ),
            paint,
          );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
