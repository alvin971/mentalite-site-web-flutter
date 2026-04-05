import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class Section06Roadmap extends StatelessWidget {
  const Section06Roadmap({super.key});

  static const _items = [
    (
      'Tests cognitifs QI (WAIS-IV)',
      'Évaluation complète basée sur le WAIS-IV · 12 sous-tests · 4 indices composites · profil cognitif détaillé · chat d\'accompagnement IA intégré',
      true,
    ),
    (
      'Intelligence émotionnelle (QE)',
      'Mesurer votre capacité à reconnaître, comprendre et gérer les émotions',
      false,
    ),
    (
      'Dépistage TDAH',
      'Questionnaires et tâches cognitives adaptés aux critères DSM-5',
      false,
    ),
    (
      'Spectre autistique',
      'Évaluation non diagnostique basée sur des outils de dépistage validés',
      false,
    ),
    (
      'Santé mentale globale',
      'Évaluation multidimensionnelle incluant anxiété, humeur et bien-être',
      false,
    ),
    (
      'IA conversationnelle avancée',
      'Modèle psychologique spécialisé avec mémoire long terme et suivi longitudinal',
      false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      color: AppColors.bg,
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
              Text(
                '§06',
                style: AppText.mono(size: 12, color: AppColors.textTertiary),
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Ce qui arrive ',
                      style: AppText.serif(size: isMobile ? 32 : 54),
                    ),
                    TextSpan(
                      text: 'bientôt',
                      style: AppText.serif(
                        size: isMobile ? 32 : 54,
                        style: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Mentality est en développement actif. Voici ce qui est déjà disponible et ce que nous construisons.',
                style: AppText.sans(
                  size: 15,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 40),
              Column(
                children: _items
                    .map((item) => _RoadmapItem(
                          label: item.$1,
                          description: item.$2,
                          available: item.$3,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoadmapItem extends StatefulWidget {
  final String label;
  final String description;
  final bool available;

  const _RoadmapItem({
    required this.label,
    required this.description,
    required this.available,
  });

  @override
  State<_RoadmapItem> createState() => _RoadmapItemState();
}

class _RoadmapItemState extends State<_RoadmapItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.accentLight : AppColors.bgWhite,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: widget.available
                      ? AppColors.accent
                      : AppColors.textTertiary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: AppText.sans(
                      size: 15,
                      color: widget.available
                          ? AppColors.text
                          : AppColors.textSecondary,
                      weight: widget.available
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: AppText.sans(
                      size: 13,
                      color: AppColors.textTertiary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: widget.available
                    ? AppColors.accent.withValues(alpha: 0.1)
                    : AppColors.bgSurface,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: widget.available
                      ? AppColors.accent.withValues(alpha: 0.3)
                      : AppColors.border,
                ),
              ),
              child: Text(
                widget.available ? 'Disponible maintenant' : 'Prochainement',
                style: AppText.sans(
                  size: 12,
                  color: widget.available
                      ? AppColors.accent
                      : AppColors.textTertiary,
                  weight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
