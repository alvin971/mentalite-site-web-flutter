import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../services/counter_service.dart';

class CtaSection extends StatefulWidget {
  final VoidCallback? onReserve;

  const CtaSection({super.key, this.onReserve});

  @override
  State<CtaSection> createState() => _CtaSectionState();
}

class _CtaSectionState extends State<CtaSection>
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
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final remaining = 10000 - _count;

    return Container(
      width: double.infinity,
      color: AppColors.bgSurface,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 48 : 80,
        horizontal: isMobile ? 20 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              Text(
                'Accès anticipé · Places limitées',
                style: AppText.sans(
                  size: 12,
                  color: AppColors.textTertiary,
                  letterSpacing: 2.0,
                  weight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Commencez à vous ',
                      style: AppText.serif(size: isMobile ? 32 : 44),
                    ),
                    TextSpan(
                      text: 'comprendre aujourd\'hui.',
                      style: AppText.serif(
                        size: isMobile ? 32 : 44,
                        style: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Gratuit. Supervisé par des cliniciens. Sans inscription obligatoire pour commencer.',
                style: AppText.sans(
                  size: 16,
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    'Places disponibles — réservez maintenant ($remaining restantes)',
                    style: AppText.sans(
                      size: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onReserve,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.bgWhite,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Réserver mon accès gratuit',
                    style: AppText.sans(
                      size: 15,
                      weight: FontWeight.w600,
                      color: AppColors.bgWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
