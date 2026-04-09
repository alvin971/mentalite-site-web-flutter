import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) context.go('/');
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: AnimatedBuilder(
                  animation: _ctrl,
                  builder: (_, __) => CustomPaint(
                    painter: _OrbitPainter(progress: _ctrl.value),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Mental E.T.',
                style: AppText.serif(
                  size: 28,
                  weight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Supervisé par des psychiatres et psychologues',
                style: AppText.sans(size: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
}

class _OrbitPainter extends CustomPainter {
  final double progress;

  _OrbitPainter({required this.progress});

  Offset _dotOnOrbit(
      double cx, double cy, double a, double b, double theta, double angle) {
    final xLocal = a * math.cos(angle);
    final yLocal = b * math.sin(angle);
    return Offset(
      xLocal * math.cos(theta) - yLocal * math.sin(theta) + cx,
      xLocal * math.sin(theta) + yLocal * math.cos(theta) + cy,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Head silhouette — scaled 2.5× vs 32px original (now 80px canvas)
    const s = 2.5;
    final headPath = Path();
    headPath.moveTo(cx, cy - 7 * s);
    headPath.cubicTo(cx + 5.0 * s, cy - 7.0 * s, cx + 5.0 * s, cy - 1.0 * s,
        cx + 4.5 * s, cy + 2.0 * s);
    headPath.cubicTo(cx + 4.0 * s, cy + 5.0 * s, cx + 2.5 * s, cy + 7.0 * s,
        cx, cy + 7.0 * s);
    headPath.cubicTo(cx - 2.5 * s, cy + 7.0 * s, cx - 4.0 * s, cy + 5.0 * s,
        cx - 4.5 * s, cy + 2.0 * s);
    headPath.cubicTo(cx - 5.0 * s, cy - 1.0 * s, cx - 5.0 * s, cy - 7.0 * s,
        cx, cy - 7.0 * s);
    headPath.close();
    canvas.drawPath(
      headPath,
      Paint()
        ..color = AppColors.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * s,
    );

    // 3 elliptical orbits at different rotations (3D atom effect)
    final orbitPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9 * s;

    const a = 12.0 * s, b = 4.0 * s;
    final orbits = [0.0, math.pi / 3, -math.pi / 3];

    for (final theta in orbits) {
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(theta);
      canvas.drawOval(
          Rect.fromCenter(center: Offset.zero, width: a * 2, height: b * 2),
          orbitPaint);
      canvas.restore();
    }

    // 6 orbiting dots — 2 per orbit, each at its own speed
    final dotPaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.fill;

    final baseAngles = [
      progress * 2 * math.pi * 1,
      progress * 2 * math.pi * 2 + (2 * math.pi / 3),
      progress * 2 * math.pi * 3 + (4 * math.pi / 3),
    ];

    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
          _dotOnOrbit(cx, cy, a, b, orbits[i], baseAngles[i]), 2.0 * s, dotPaint);
      canvas.drawCircle(
          _dotOnOrbit(cx, cy, a, b, orbits[i], baseAngles[i] + math.pi),
          2.0 * s,
          dotPaint);
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter old) => old.progress != progress;
}
