import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class Section03Profile extends StatelessWidget {
  const Section03Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      color: AppColors.bgSurface,
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
              // §03
              Text(
                '§03',
                style: AppText.mono(size: 11, color: AppColors.textTertiary),
              ),
              const SizedBox(height: 14),
              // Title
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Votre ',
                      style: AppText.serif(size: isMobile ? 32 : 44),
                    ),
                    TextSpan(
                      text: 'profil cognitif',
                      style: AppText.serif(
                        size: isMobile ? 32 : 44,
                        style: FontStyle.italic,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 52),
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBodyText(),
                    const SizedBox(height: 24),
                    const _QiCard(),
                    const SizedBox(height: 24),
                    const _ProfileGrid(),
                    const SizedBox(height: 16),
                    const _ProfileNote(),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBodyText(),
                          const SizedBox(height: 24),
                          const _QiCard(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 72),
                    const Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          _ProfileGrid(),
                          SizedBox(height: 16),
                          _ProfileNote(),
                        ],
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

  Widget _buildBodyText() {
    return Text(
      'Mentality génère un profil cognitif complet à partir de vos résultats — quatre indices mesurés avec la même rigueur que lors d\'une évaluation clinique.',
      style: AppText.sans(
        size: 15,
        color: AppColors.textSecondary,
        height: 1.6,
      ),
    );
  }
}

class _QiCard extends StatelessWidget {
  const _QiCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QI estimé global',
                  style: AppText.mono(
                    size: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '118',
                  style: AppText.serif(
                    size: 36,
                    weight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '88e percentile · Supérieur',
                  style: AppText.mono(
                    size: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentDim,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              'Supérieur',
              style: AppText.sans(
                size: 12,
                color: AppColors.accent,
                weight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileGrid extends StatelessWidget {
  const _ProfileGrid();

  static const _scores = [
    ('ICV', 'Compréhension verbale', 122, 160, '93e percentile',
        AppColors.verbal),
    ('IRP', 'Raisonnement perceptif', 115, 160, '84e percentile',
        AppColors.visuel),
    ('IMT', 'Mémoire de travail', 108, 160, '70e percentile',
        AppColors.memoire),
    ('IVT', 'Vitesse de traitement', 119, 160, '90e percentile',
        AppColors.vitesse),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ProfileCard(
                abbr: _scores[0].$1,
                label: _scores[0].$2,
                score: _scores[0].$3,
                max: _scores[0].$4,
                percentile: _scores[0].$5,
                color: _scores[0].$6,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ProfileCard(
                abbr: _scores[1].$1,
                label: _scores[1].$2,
                score: _scores[1].$3,
                max: _scores[1].$4,
                percentile: _scores[1].$5,
                color: _scores[1].$6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ProfileCard(
                abbr: _scores[2].$1,
                label: _scores[2].$2,
                score: _scores[2].$3,
                max: _scores[2].$4,
                percentile: _scores[2].$5,
                color: _scores[2].$6,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ProfileCard(
                abbr: _scores[3].$1,
                label: _scores[3].$2,
                score: _scores[3].$3,
                max: _scores[3].$4,
                percentile: _scores[3].$5,
                color: _scores[3].$6,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileCard extends StatefulWidget {
  final String abbr;
  final String label;
  final int score;
  final int max;
  final String percentile;
  final Color color;

  const _ProfileCard({
    required this.abbr,
    required this.label,
    required this.score,
    required this.max,
    required this.percentile,
    required this.color,
  });

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final fraction = (widget.score / widget.max).clamp(0.0, 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        padding: const EdgeInsets.all(18),
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
            Text(
              widget.abbr,
              style: AppText.mono(
                size: 18,
                weight: FontWeight.w600,
                color: widget.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: AppText.sans(
                size: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                height: 4,
                color: AppColors.bgSurface,
                child: FractionallySizedBox(
                  widthFactor: fraction,
                  alignment: Alignment.centerLeft,
                  child: Container(color: widget.color),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.score}',
                  style: AppText.mono(
                    size: 11,
                    color: AppColors.text,
                    weight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.percentile,
                  style: AppText.mono(
                    size: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileNote extends StatelessWidget {
  const _ProfileNote();

  @override
  Widget build(BuildContext context) {
    return Text(
      'À titre illustratif · résultats non diagnostiques',
      style: AppText.mono(
        size: 11,
        color: AppColors.textTertiary,
      ),
      textAlign: TextAlign.center,
    );
  }
}
