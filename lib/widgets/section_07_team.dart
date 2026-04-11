import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import 'scroll_reveal.dart';

class Section07Team extends StatelessWidget {
  const Section07Team({super.key});

  static const _members = [
    (
      'DR',
      'Psychiatre',
      'Supervision des tests',
      'La rigueur diagnostique est la base de tout outil clinique crédible.',
    ),
    (
      'PS',
      'Psychologue clinicien',
      'Accompagnement IA',
      'L\'IA peut créer un espace d\'écoute authentique quand elle est bien encadrée.',
    ),
    (
      'NP',
      'Neuropsychologue',
      'Tests cognitifs',
      'Les normes WAIS-IV sont notre boussole — pas de raccourcis psychométriques.',
    ),
    (
      'RE',
      'Chercheur en psychométrie',
      'Validation scientifique',
      'Chaque item de test passe par une validation empirique avant publication.',
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
              Text(
                '§07',
                style: AppText.mono(size: 12, color: AppColors.textTertiary),
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Supervisé par de ',
                      style: AppText.serif(size: isMobile ? 32 : 54),
                    ),
                    TextSpan(
                      text: 'vrais cliniciens',
                      style: AppText.serif(
                        size: isMobile ? 32 : 54,
                        style: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              if (isMobile)
                Column(
                  children: List.generate(_members.length, (i) => ScrollReveal(
                    key: ValueKey('team-card-$i'),
                    delay: Duration(milliseconds: i * 100),
                    slideOffset: 0.08,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _TeamCard(
                        initials: _members[i].$1,
                        role: _members[i].$2,
                        tag: _members[i].$3,
                        quote: _members[i].$4,
                      ),
                    ),
                  )),
                )
              else
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.7,
                  children: List.generate(_members.length, (i) => ScrollReveal(
                    key: ValueKey('team-card-$i'),
                    delay: Duration(milliseconds: i * 100),
                    slideOffset: 0.08,
                    child: _TeamCard(
                      initials: _members[i].$1,
                      role: _members[i].$2,
                      tag: _members[i].$3,
                      quote: _members[i].$4,
                    ),
                  )),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamCard extends StatefulWidget {
  final String initials;
  final String role;
  final String tag;
  final String quote;

  const _TeamCard({
    required this.initials,
    required this.role,
    required this.tag,
    required this.quote,
  });

  @override
  State<_TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<_TeamCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(2),
          boxShadow: _hovered
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 8))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.accentLight,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.initials,
                      style: AppText.mono(
                        size: 16,
                        color: AppColors.accent,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.role,
                        style: AppText.sans(
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.tag,
                        style: AppText.sans(
                          size: 11,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Quote with border-left
            Container(
              padding: const EdgeInsets.only(left: 14),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: AppColors.accent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                widget.quote,
                style: AppText.serif(
                  size: 14,
                  color: AppColors.textSecondary,
                  style: FontStyle.italic,
                  height: 1.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

