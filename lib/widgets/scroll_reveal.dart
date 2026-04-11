import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Widget wrapper qui déclenche une animation fadeIn + slideUp
/// quand il entre dans le viewport (visibleFraction > 0.08).
/// L'animation ne se rejoue pas si on remonte puis redescend.
class ScrollReveal extends StatefulWidget {
  final Widget child;

  /// Délai avant le démarrage de l'animation (pour les effets en cascade).
  final Duration delay;

  /// Durée de l'animation fade + slide.
  final Duration duration;

  /// Translation verticale initiale en fraction de la taille de l'enfant.
  /// Ex : 0.06 = 6% de la hauteur du widget.
  final double slideOffset;

  const ScrollReveal({
    required super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 550),
    this.slideOffset = 0.06,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
  bool _visible = false;
  bool _triggered = false;

  void _onVisibilityChanged(VisibilityInfo info) {
    if (_triggered || info.visibleFraction <= 0.08) return;
    _triggered = true;
    if (widget.delay == Duration.zero) {
      if (mounted) setState(() => _visible = true);
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) setState(() => _visible = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key!,
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: AnimatedSlide(
          offset: _visible ? Offset.zero : Offset(0, widget.slideOffset),
          duration: widget.duration,
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
