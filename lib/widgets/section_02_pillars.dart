import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class Section02Pillars extends StatelessWidget {
  const Section02Pillars({super.key});

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
              // Section label pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentDim,
                  border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'LA PLATEFORME',
                  style: AppText.mono(
                    size: 11,
                    color: AppColors.accent,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // H2
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Trois piliers pour prendre soin de ',
                      style: AppText.serif(size: isMobile ? 32 : 54),
                    ),
                    TextSpan(
                      text: 'votre esprit.',
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
              if (isMobile)
                Column(
                  children: const [
                    _PillarCard(
                      icon: Icons.psychology,
                      number: '01',
                      title: 'Évaluation cognitive complète',
                      body:
                          '12 tests basés sur le WAIS-IV · 4 indices composites · profil détaillé de vos forces et fragilités cognitives',
                    ),
                    SizedBox(height: 16),
                    _PillarCard(
                      icon: Icons.chat_bubble_outline,
                      number: '02',
                      title: 'Accompagnement psychologique IA',
                      body:
                          'Un espace d\'écoute active disponible 24h/24 · pour comprendre vos résultats et explorer ce que vous ressentez',
                    ),
                    SizedBox(height: 16),
                    _PillarCard(
                      icon: Icons.shield_outlined,
                      number: '03',
                      title: 'Supervision clinique réelle',
                      body:
                          'Chaque test est validé et amélioré en continu par des psychiatres et psychologues partenaires',
                    ),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(
                      child: _PillarCard(
                        icon: Icons.psychology,
                        number: '01',
                        title: 'Évaluation cognitive complète',
                        body:
                            '12 tests basés sur le WAIS-IV · 4 indices composites · profil détaillé de vos forces et fragilités cognitives',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _PillarCard(
                        icon: Icons.chat_bubble_outline,
                        number: '02',
                        title: 'Accompagnement psychologique IA',
                        body:
                            'Un espace d\'écoute active disponible 24h/24 · pour comprendre vos résultats et explorer ce que vous ressentez',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _PillarCard(
                        icon: Icons.shield_outlined,
                        number: '03',
                        title: 'Supervision clinique réelle',
                        body:
                            'Chaque test est validé et amélioré en continu par des psychiatres et psychologues partenaires',
                      ),
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

class _PillarCard extends StatefulWidget {
  final IconData icon;
  final String number;
  final String title;
  final String body;

  const _PillarCard({
    required this.icon,
    required this.number,
    required this.title,
    required this.body,
  });

  @override
  State<_PillarCard> createState() => _PillarCardState();
}

class _PillarCardState extends State<_PillarCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(2),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(widget.icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.number,
                  style: AppText.mono(
                    size: 13,
                    color: AppColors.accent,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: AppText.sans(
                size: 15,
                weight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
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
    );
  }
}

