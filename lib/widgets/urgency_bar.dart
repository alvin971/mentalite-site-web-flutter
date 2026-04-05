import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../services/counter_service.dart';

class UrgencyBar extends StatefulWidget {
  const UrgencyBar({super.key});

  @override
  State<UrgencyBar> createState() => _UrgencyBarState();
}

class _UrgencyBarState extends State<UrgencyBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  int _count = CounterService().currentCount;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.3, end: 1.0).animate(_pulseController);

    CounterService().stream.listen((count) {
      if (mounted) setState(() => _count = count);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = 10000 - _count;
    return Container(
      width: double.infinity,
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.bgWhite,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, __) => Opacity(
                      opacity: _pulseAnim.value,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Places disponibles en accès anticipé — ',
                    style: AppText.sans(
                      size: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '$remaining restantes',
                    style: AppText.sans(
                      size: 13,
                      weight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
