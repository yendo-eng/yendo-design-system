import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../colors.dart';

// ── Yendo Confetti ──────────────────────────────────────────────────────────
//
// Fintech-grade celebration animation. Deliberately restrained:
//   • Brand colors only (orange, green, yellow, navy tints)
//   • Small geometric particles — dots & thin ribbons, no stars/triangles
//   • Single burst that plays once, fades out cleanly
//   • Sits in an IgnorePointer overlay so it never blocks taps
//
// Usage:
//   Stack(children: [
//     YourScreen(),
//     const YendoConfetti(),           // auto-plays on mount
//   ])
//
// Or wrap a screen with it:
//   YendoConfetti.wrap(child: YourScreen())

class YendoConfetti extends StatefulWidget {
  const YendoConfetti({super.key, this.particleCount = 72});

  /// Total number of particles in the burst.
  final int particleCount;

  /// Convenience wrapper — confetti sits BEHIND [child].
  /// [backgroundColor] fills the bottom of the stack so the screen
  /// colour is preserved when the child uses a transparent background.
  static Widget wrap({
    required Widget child,
    int particleCount = 72,
    Color backgroundColor = const Color(0xFFF5F7FA), // AppColors.neutralN50
  }) {
    return Stack(
      children: [
        // Solid background so transparent-scaffold screens don't go black
        Positioned.fill(child: ColoredBox(color: backgroundColor)),
        // Confetti in the background layer
        YendoConfetti(particleCount: particleCount),
        // Screen content on top — cards/bars with solid fills block confetti;
        // transparent padding areas let it show through
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
  late final List<_Particle> _particles;
  final math.Random _rng = math.Random();

  // Brand palette — same saturation/lightness family, no off-brand colors
  static const _colors = [
    AppColors.primaryO400, // signature orange
    AppColors.primaryO300, // light orange
    AppColors.green400, // success green
    AppColors.yellow400, // warm yellow
    Color(0xFF1A2B5C), // navy tint (lighter than navy for visibility)
    AppColors.neutralN200, // soft gray-blue — grounds the palette
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    _particles = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = MediaQuery.of(context).size;
      _buildParticles(size);
      // setState so the AnimatedBuilder re-renders with the real particles
      setState(() {});
      _controller.forward();
    });
  }

  void _buildParticles(Size size) {
    _particles.clear();
    final cx = size.width / 2;
    for (int i = 0; i < widget.particleCount; i++) {
      // Spread origin slightly around center-top so burst feels natural
      final ox = cx + _rng.nextDouble() * 80 - 40;
      final oy = -10.0;

      // Wide fan angle so particles scatter across the full screen width
      final angle = math.pi / 2 + (_rng.nextDouble() - 0.5) * math.pi * 1.1;
      // Slower speed so particles are still on-screen when they freeze
      final speed = 120 + _rng.nextDouble() * 160;

      _particles.add(_Particle(
        origin: Offset(ox, oy),
        velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed),
        color: _colors[_rng.nextInt(_colors.length)],
        shape: _rng.nextBool() ? _Shape.dot : _Shape.ribbon,
        size: _rng.nextDouble() * 5 + 4, // 4–9 px
        rotationSpeed: (_rng.nextDouble() - 0.5) * 8,
        horizontalDrift: (_rng.nextDouble() - 0.5) * 60,
        phaseOffset: _rng.nextDouble() * 0.2, // stagger start slightly
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
          animation: _controller,
          builder: (_, __) {
            return CustomPaint(
              painter: _ConfettiPainter(
                particles: _particles,
                progress: _controller.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Particle model ───────────────────────────────────────────────────────────

enum _Shape { dot, ribbon }

class _Particle {
  const _Particle({
    required this.origin,
    required this.velocity,
    required this.color,
    required this.shape,
    required this.size,
    required this.rotationSpeed,
    required this.horizontalDrift,
    required this.phaseOffset,
  });

  final Offset origin;
  final Offset velocity;
  final Color color;
  final _Shape shape;
  final double size;
  final double rotationSpeed;
  final double horizontalDrift; // subtle sine-wave side drift
  final double phaseOffset; // [0, 0.25] — staggered entry
}

// ── Painter ──────────────────────────────────────────────────────────────────

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  final List<_Particle> particles;
  final double progress; // 0.0 → 1.0

  // Gravity acceleration (pixels/s²) — gentle so particles land on-screen
  static const double _gravity = 140;

  // Particles stop moving at this progress point, then fade to resting state.
  // Keeps them on-screen so the persistence effect is actually visible.
  static const double _freezeAt = 0.55;
  static const double _fadeEnd = 0.75; // tighter window = snappier settle
  static const double _persistentAlpha = 0.25;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      // Each particle has its own local progress after its phase offset
      final t = ((progress - p.phaseOffset) / (1.0 - p.phaseOffset))
          .clamp(0.0, 1.0);
      if (t <= 0) continue;

      // Physics: freeze position at _freezeAt so particles stay on-screen
      final tPhysics = math.min(t, _freezeAt);
      final dt = tPhysics * 1.4; // map 0-0.55 to 0-0.77 s
      final x = p.origin.dx +
          p.velocity.dx * dt +
          p.horizontalDrift * math.sin(dt * math.pi);
      final y = p.origin.dy +
          p.velocity.dy * dt +
          0.5 * _gravity * dt * dt;

      // Opacity: full during burst → ease-out fade → hold at persistent alpha.
      // Ease-out curve (t²·(3-2t) = smoothstep) drops quickly then glides in,
      // eliminating the mechanical linear-fade lag.
      final opacity = t < _freezeAt
          ? 1.0
          : t < _fadeEnd
              ? () {
                  final raw = (t - _freezeAt) / (_fadeEnd - _freezeAt);
                  // smoothstep: fast start, gentle landing
                  final curved = raw * raw * (3.0 - 2.0 * raw);
                  return 1.0 - (1.0 - _persistentAlpha) * curved;
                }()
              : _persistentAlpha;

      paint.color = p.color.withValues(alpha: opacity);
      final rotation = p.rotationSpeed * dt;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      if (p.shape == _Shape.dot) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        // Ribbon: thin elongated rectangle
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: p.size * 0.45,
              height: p.size * 2.4,
            ),
            const Radius.circular(1),
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
