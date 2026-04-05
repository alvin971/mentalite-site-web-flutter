import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class Section04Tests extends StatelessWidget {
  const Section04Tests({super.key, this.sectionKey});

  final GlobalKey? sectionKey;

  static const _tests = [
    ('01', 'Similitudes',
        'Trouver ce que deux concepts ont en commun · raisonnement abstrait et pensée catégorielle',
        'Verbal', 0),
    ('02', 'Vocabulaire',
        'Définir des mots · étendue du vocabulaire et capacité à exprimer des idées',
        'Verbal', 0),
    ('03', 'Information',
        'Répondre à des questions de culture générale · base de connaissances acquises',
        'Verbal', 0),
    ('04', 'Cubes',
        'Reproduire des motifs abstraits avec des cubes · raisonnement spatial et organisation perceptive',
        'Visuel', 1),
    ('05', 'Matrices',
        'Compléter des séquences visuelles · raisonnement inductif et logique non verbale',
        'Visuel', 1),
    ('06', 'Puzzles visuels',
        'Reconstituer une image à partir de fragments · synthèse visuelle et rotation mentale',
        'Visuel', 1),
    ('07', 'Empan de chiffres',
        'Mémoriser et restituer des séries de chiffres · mémoire à court terme et contrôle attentionnel',
        'Mémoire', 2),
    ('08', 'Arithmétique',
        'Résoudre des problèmes numériques mentalement · raisonnement quantitatif et concentration',
        'Mémoire', 2),
    ('09', 'Balances',
        'Trouver l\'équation manquante · raisonnement quantitatif et logique séquentielle',
        'Mémoire', 2),
    ('10', 'Code',
        'Associer des symboles à des chiffres rapidement · vitesse de traitement et apprentissage procédural',
        'Vitesse', 3),
    ('11', 'Recherche de symboles',
        'Repérer des cibles dans des séries · vitesse perceptive et discrimination visuelle',
        'Vitesse', 3),
    ('12', 'Mémoire d\'images',
        'Mémoriser des images dans un ordre précis · mémoire visuelle séquentielle',
        'Vitesse', 3),
  ];

  // Tag colors: 0=Verbal, 1=Visuel, 2=Mémoire, 3=Vitesse
  static const _tagColors = [
    AppColors.verbal,
    AppColors.visuel,
    AppColors.memoire,
    AppColors.vitesse,
  ];

  static const _tagBgs = [
    Color(0x174D7C4A), // rgba(77,124,74,0.09)
    Color(0x175E7C6F), // rgba(94,124,111,0.09)
    Color(0x173D7A5C), // rgba(61,122,92,0.09)
    Color(0x178A7C4A), // rgba(138,124,74,0.09)
  ];

  // Indice badges
  static const _indices = [
    ('ICV', 'Compréhension verbale', 0),
    ('IRP', 'Raisonnement perceptif', 1),
    ('IMT', 'Mémoire de travail', 2),
    ('IVT', 'Vitesse de traitement', 3),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      key: sectionKey,
      width: double.infinity,
      color: AppColors.bg,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 48 : 100,
        horizontal: isMobile ? 20 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // §04
              Text(
                '§04',
                style: AppText.mono(size: 11, color: AppColors.textTertiary),
              ),
              const SizedBox(height: 14),
              // Title
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Basé sur le ',
                      style: AppText.serif(size: isMobile ? 32 : 44),
                    ),
                    TextSpan(
                      text: 'WAIS-IV',
                      style: AppText.serif(
                        size: isMobile ? 32 : 44,
                        style: FontStyle.italic,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'La batterie de tests d\'intelligence la plus utilisée et validée scientifiquement dans le monde.',
                style: AppText.sans(
                  size: 15,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 36),
              // Indice badges
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _indices.map((idx) {
                  final color = _tagColors[idx.$3];
                  final bg = _tagBgs[idx.$3];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      '${idx.$1} · ${idx.$2}',
                      style: AppText.mono(size: 11, color: color),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 36),
              // Tests grid
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  color: AppColors.bgWhite,
                ),
                child: isMobile
                    ? Column(
                        children: List.generate(_tests.length, (i) {
                          return _TestItem(
                            num: _tests[i].$1,
                            name: _tests[i].$2,
                            description: _tests[i].$3,
                            tag: _tests[i].$4,
                            tagColor: _tagColors[_tests[i].$5],
                            tagBg: _tagBgs[_tests[i].$5],
                            showBottomBorder: i < _tests.length - 1,
                            showRightBorder: false,
                          );
                        }),
                      )
                    : Column(
                        children: List.generate(6, (row) {
                          final left = _tests[row * 2];
                          final right = _tests[row * 2 + 1];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _TestItem(
                                  num: left.$1,
                                  name: left.$2,
                                  description: left.$3,
                                  tag: left.$4,
                                  tagColor: _tagColors[left.$5],
                                  tagBg: _tagBgs[left.$5],
                                  showBottomBorder: row < 5,
                                  showRightBorder: true,
                                ),
                              ),
                              Expanded(
                                child: _TestItem(
                                  num: right.$1,
                                  name: right.$2,
                                  description: right.$3,
                                  tag: right.$4,
                                  tagColor: _tagColors[right.$5],
                                  tagBg: _tagBgs[right.$5],
                                  showBottomBorder: row < 5,
                                  showRightBorder: false,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestItem extends StatefulWidget {
  final String num;
  final String name;
  final String description;
  final String tag;
  final Color tagColor;
  final Color tagBg;
  final bool showBottomBorder;
  final bool showRightBorder;

  const _TestItem({
    required this.num,
    required this.name,
    required this.description,
    required this.tag,
    required this.tagColor,
    required this.tagBg,
    required this.showBottomBorder,
    required this.showRightBorder,
  });

  @override
  State<_TestItem> createState() => _TestItemState();
}

class _TestItemState extends State<_TestItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.accentLight : Colors.transparent,
          border: Border(
            bottom: widget.showBottomBorder
                ? BorderSide(color: AppColors.border)
                : BorderSide.none,
            right: widget.showRightBorder
                ? BorderSide(color: AppColors.border)
                : BorderSide.none,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Num
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: SizedBox(
                width: 24,
                child: Text(
                  widget.num,
                  style: AppText.mono(
                      size: 10, color: AppColors.textTertiary),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Name + description + tag
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: AppText.sans(
                      size: 14,
                      weight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: AppText.sans(
                      size: 12,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.tagBg,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      widget.tag,
                      style: AppText.mono(
                          size: 10, color: widget.tagColor),
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
