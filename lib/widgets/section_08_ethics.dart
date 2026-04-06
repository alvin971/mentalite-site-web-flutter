import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class Section08Ethics extends StatelessWidget {
  const Section08Ethics({super.key});

  static const _items = [
    (
      Icons.favorite_border,
      AppColors.accentDim,
      'Gratuit pour toujours',
      'Le test cognitif complet et le chat seront toujours gratuits. Aucune fonctionnalité essentielle derrière un paywall.',
    ),
    (
      Icons.warning_amber_rounded,
      Color(0x1FAA8800),
      'Pas un outil de diagnostic',
      'Mental E.T. ne diagnostique pas. Il éclaire, accompagne, informe.',
    ),
    (
      Icons.lock_outline,
      AppColors.accentDim,
      'Données protégées',
      'Anonymisées, chiffrées, jamais vendues à des assureurs, employeurs ou annonceurs.',
    ),
    (
      Icons.language,
      AppColors.accentDim,
      'Accessible à tous',
      '10 langues, mobile et desktop. Pour chacun, partout.',
    ),
    (
      Icons.arrow_circle_right_outlined,
      AppColors.accentDim,
      'Orienté vers le soin',
      'Mental E.T. vous aide à trouver des professionnels qualifiés.',
    ),
    (
      Icons.science_outlined,
      AppColors.accentDim,
      'Fondé sur la science',
      'Chaque test guidé par la littérature scientifique.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      color: AppColors.bgSurface,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 48 : 80,
        horizontal: isMobile ? 20 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // H2 — no label for this section
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Une charte éthique ',
                      style: AppText.serif(size: isMobile ? 32 : 54),
                    ),
                    TextSpan(
                      text: 'sans compromis.',
                      style: AppText.serif(
                        size: isMobile ? 32 : 54,
                        style: FontStyle.italic,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Column(
                children: _items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _EthicsCard(
                          icon: item.$1,
                          iconBg: item.$2,
                          title: item.$3,
                          body: item.$4,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EthicsCard extends StatefulWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String body;

  const _EthicsCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.body,
  });

  @override
  State<_EthicsCard> createState() => _EthicsCardState();
}

class _EthicsCardState extends State<_EthicsCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.accentLight : AppColors.bgWhite,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(2),
          boxShadow: _hovered
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, size: 20, color: AppColors.accent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: AppText.sans(
                      size: 15,
                      weight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.body,
                    style: AppText.sans(
                      size: 13,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
