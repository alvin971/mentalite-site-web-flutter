import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class NavbarWidget extends StatefulWidget {
  final ScrollController scrollController;
  final VoidCallback? onReserve;
  final VoidCallback? onScrollToTests;
  final VoidCallback? onScrollToAccompagnement;

  const NavbarWidget({
    super.key,
    required this.scrollController,
    this.onReserve,
    this.onScrollToTests,
    this.onScrollToAccompagnement,
  });

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget>
    with SingleTickerProviderStateMixin {
  bool _isScrolled = false;
  bool _drawerOpen = false;
  late AnimationController _orbitController;

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = widget.scrollController.offset > 60;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  @override
  void dispose() {
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: _isScrolled
              ? BoxDecoration(
                  color: const Color(0xBFD7E8D2),
                  border: const Border(
                    bottom: BorderSide(color: AppColors.border),
                  ),
                )
              : const BoxDecoration(color: Colors.transparent),
          child: _isScrolled
              ? ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: defaultTargetPlatform == TargetPlatform.iOS ? 10 : 28,
                      sigmaY: defaultTargetPlatform == TargetPlatform.iOS ? 10 : 28,
                    ),
                    child: _NavContent(
                      isMobile: isMobile,
                      orbitController: _orbitController,
                      onReserve: widget.onReserve,
                      onScrollToTests: widget.onScrollToTests,
                      onScrollToAccompagnement: widget.onScrollToAccompagnement,
                      onMenuTap: () => setState(() => _drawerOpen = true),
                    ),
                  ),
                )
              : _NavContent(
                  isMobile: isMobile,
                  orbitController: _orbitController,
                  onReserve: widget.onReserve,
                  onScrollToTests: widget.onScrollToTests,
                  onScrollToAccompagnement: widget.onScrollToAccompagnement,
                  onMenuTap: () => setState(() => _drawerOpen = true),
                ),
        ),
        if (_drawerOpen)
          _MobileDrawer(
            onClose: () => setState(() => _drawerOpen = false),
            onReserve: () {
              setState(() => _drawerOpen = false);
              widget.onReserve?.call();
            },
            onScrollToTests: () {
              setState(() => _drawerOpen = false);
              widget.onScrollToTests?.call();
            },
            onScrollToAccompagnement: () {
              setState(() => _drawerOpen = false);
              widget.onScrollToAccompagnement?.call();
            },
          ),
      ],
    );
  }
}

class _NavContent extends StatelessWidget {
  final bool isMobile;
  final AnimationController orbitController;
  final VoidCallback? onReserve;
  final VoidCallback? onScrollToTests;
  final VoidCallback? onScrollToAccompagnement;
  final VoidCallback onMenuTap;

  const _NavContent({
    required this.isMobile,
    required this.orbitController,
    required this.onMenuTap,
    this.onReserve,
    this.onScrollToTests,
    this.onScrollToAccompagnement,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 48,
          vertical: 14,
        ),
        child: Row(
          children: [
            _LogoWidget(orbitController: orbitController),
            const Spacer(),
            if (isMobile)
              GestureDetector(
                onTap: onMenuTap,
                child: Icon(
                  Icons.menu,
                  color: AppColors.accent,
                  size: 24,
                ),
              )
            else
              Row(
                children: [
                  _NavLink(label: 'Les tests', onTap: onScrollToTests),
                  const SizedBox(width: 28),
                  _NavLink(
                    label: 'Accompagnement',
                    onTap: onScrollToAccompagnement,
                  ),
                  const SizedBox(width: 28),
                  _ReserveButton(onTap: onReserve),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _LogoWidget extends StatelessWidget {
  final AnimationController orbitController;

  const _LogoWidget({required this.orbitController});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: AnimatedBuilder(
            animation: orbitController,
            builder: (_, __) => CustomPaint(
              painter: _OrbitPainter(progress: orbitController.value),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Mental E.T.',
              style: AppText.serif(
                size: 22,
                weight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            Text(
              'Supervisé par des psychiatres et psychologues',
              style: AppText.sans(
                size: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final double progress;

  _OrbitPainter({required this.progress});

  Offset _dotOnOrbit(double cx, double cy, double a, double b, double theta, double angle) {
    final xLocal = a * math.cos(angle);
    final yLocal = b * math.sin(angle);
    final xWorld = xLocal * math.cos(theta) - yLocal * math.sin(theta) + cx;
    final yWorld = xLocal * math.sin(theta) + yLocal * math.cos(theta) + cy;
    return Offset(xWorld, yWorld);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Human head silhouette (front view, mannequin — no facial features)
    final headPath = Path();
    headPath.moveTo(cx, cy - 7);
    // Right side: cranium → cheek → chin
    headPath.cubicTo(cx + 5.0, cy - 7.0, cx + 5.0, cy - 1.0, cx + 4.5, cy + 2.0);
    headPath.cubicTo(cx + 4.0, cy + 5.0, cx + 2.5, cy + 7.0, cx, cy + 7.0);
    // Left side: chin → cheek → cranium (mirror)
    headPath.cubicTo(cx - 2.5, cy + 7.0, cx - 4.0, cy + 5.0, cx - 4.5, cy + 2.0);
    headPath.cubicTo(cx - 5.0, cy - 1.0, cx - 5.0, cy - 7.0, cx, cy - 7.0);
    headPath.close();

    final headPaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(headPath, headPaint);

    // 3 elliptical orbit paths at different rotations (3D atom effect)
    final orbitPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    const a = 12.0;
    const b = 4.0;
    final orbits = [0.0, math.pi / 3, -math.pi / 3];

    for (final theta in orbits) {
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(theta);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: a * 2, height: b * 2), orbitPaint);
      canvas.restore();
    }

    // 6 orbiting dots — 2 per orbit (180° apart), each orbit at its own speed
    final dotPaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.fill;

    // Integer speed multipliers → seamless loop. Phase offset 120° (2π/3) between each orbit.
    final baseAngles = [
      progress * 2 * math.pi * 1,
      progress * 2 * math.pi * 2 + (2 * math.pi / 3),
      progress * 2 * math.pi * 3 + (4 * math.pi / 3),
    ];

    for (int i = 0; i < 3; i++) {
      final pos1 = _dotOnOrbit(cx, cy, a, b, orbits[i], baseAngles[i]);
      canvas.drawCircle(pos1, 2.0, dotPaint);
      final pos2 = _dotOnOrbit(cx, cy, a, b, orbits[i], baseAngles[i] + math.pi);
      canvas.drawCircle(pos2, 2.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _NavLink extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _NavLink({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: AppText.sans(
          size: 14,
          color: AppColors.textSecondary,
          weight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ReserveButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _ReserveButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.text,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          'Réserver mon accès',
          style: AppText.sans(
            size: 13,
            weight: FontWeight.w600,
            color: AppColors.bgWhite,
          ),
        ),
      ),
    );
  }
}

class _MobileDrawer extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onReserve;
  final VoidCallback? onScrollToTests;
  final VoidCallback? onScrollToAccompagnement;

  const _MobileDrawer({
    required this.onClose,
    this.onReserve,
    this.onScrollToTests,
    this.onScrollToAccompagnement,
  });

  @override
  State<_MobileDrawer> createState() => _MobileDrawerState();
}

class _MobileDrawerState extends State<_MobileDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: const Color(0xFF0B1F17),
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  right: 20,
                  child: GestureDetector(
                    onTap: widget.onClose,
                    child: const Icon(Icons.close, size: 28, color: Colors.white),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _FullscreenMenuLink(
                        label: 'Les tests',
                        onTap: widget.onScrollToTests,
                      ),
                      const SizedBox(height: 32),
                      _FullscreenMenuLink(
                        label: 'Accompagnement',
                        onTap: widget.onScrollToAccompagnement,
                      ),
                      const SizedBox(height: 32),
                      _FullscreenMenuLink(
                        label: 'Réserver',
                        onTap: widget.onReserve,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FullscreenMenuLink extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _FullscreenMenuLink({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: AppText.serif(
          size: 32,
          color: Colors.white,
          weight: FontWeight.w400,
        ),
      ),
    );
  }
}
