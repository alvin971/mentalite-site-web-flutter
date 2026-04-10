import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../services/counter_service.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback? onReserve;
  final VoidCallback? onDiscoverTests;

  const HeroSection({
    super.key,
    this.onReserve,
    this.onDiscoverTests,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  int _count = CounterService().currentCount;

  @override
  void initState() {
    super.initState();
    CounterService().start();
    CounterService().stream.listen((count) {
      if (mounted) setState(() => _count = count);
    });
  }

  String _formatCount(int n) {
    if (n >= 1000) {
      final thousands = n ~/ 1000;
      final remainder = n % 1000;
      if (remainder == 0) return '$thousands\u202f000';
      return '$thousands\u202f${remainder.toString().padLeft(3, '0')}';
    }
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final oversubscribed = _count > 10000;
    final excess = _count - 10000;
    final progress = (_count / 10000).clamp(0.0, 1.0);
    final percent = (_count / 10000 * 100).round();

    final topPadding = MediaQuery.of(context).viewPadding.top;

    return Container(
      width: double.infinity,
      color: AppColors.bg,
      padding: EdgeInsets.only(
        top: (isMobile ? 100 : 160) + topPadding,
        bottom: isMobile ? 48 : 100,
        left: isMobile ? 20 : 48,
        right: isMobile ? 20 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: math.min(width * 0.95, 780)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Eyebrow pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  'Accès anticipé · 10 000 places',
                  style: AppText.sans(
                    size: 11,
                    color: AppColors.accent,
                    weight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 28),
              // H1
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Votre santé mentale mérite une ',
                      style: AppText.serif(
                        size: isMobile ? 36 : 54,
                        height: 1.15,
                      ),
                    ),
                    TextSpan(
                      text: 'attention sérieuse.',
                      style: AppText.serif(
                        size: isMobile ? 36 : 54,
                        style: FontStyle.italic,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Lead
              Text(
                'Évaluez votre intelligence cognitive avec les mêmes outils que les neuropsychologues, bénéficiez d\'un accompagnement IA supervisé par des cliniciens, et comprenez votre profil mental en profondeur — gratuitement.',
                style: AppText.sans(
                  size: 16,
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              // Counter card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Places réservées',
                          style: AppText.sans(
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_formatCount(_count)} / 10\u202f000',
                          style: AppText.mono(
                            size: 14,
                            color: AppColors.text,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: const Color(0xFFCCCCCC),
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$percent% des places prises',
                          style: AppText.mono(
                            size: 12,
                            color: oversubscribed ? AppColors.accent : AppColors.textTertiary,
                            weight: oversubscribed ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        Text(
                          oversubscribed
                              ? '+${_formatCount(excess)} en liste d\'attente'
                              : '${_formatCount(10000 - _count)} restantes',
                          style: AppText.mono(
                            size: 12,
                            color: oversubscribed ? AppColors.accent : AppColors.textTertiary,
                            weight: oversubscribed ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // CTAs
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _PrimaryButton(
                      label: 'Réserver mon accès gratuit',
                      onTap: widget.onReserve,
                    ),
                    const SizedBox(height: 14),
                    _SecondaryButton(
                      label: 'Découvrir les tests →',
                      onTap: widget.onDiscoverTests,
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _PrimaryButton(
                      label: 'Réserver mon accès gratuit',
                      onTap: widget.onReserve,
                    ),
                    const SizedBox(width: 24),
                    _SecondaryButton(
                      label: 'Découvrir les tests →',
                      onTap: widget.onDiscoverTests,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _PrimaryButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 0,
      ),
      child: Text(
        label,
        style: AppText.sans(
          size: 14,
          weight: FontWeight.w500,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _SecondaryButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accent,
        side: BorderSide(color: AppColors.accent),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Text(
        label,
        style: AppText.sans(
          size: 14,
          weight: FontWeight.w400,
          color: AppColors.accent,
        ),
      ),
    );
  }
}
