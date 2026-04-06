import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class Section01Conviction extends StatelessWidget {
  const Section01Conviction({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      color: AppColors.darkBg,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 48 : 64,
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
                  color: const Color(0x1A4D7C4A),
                  border: Border.all(color: const Color(0x334D7C4A)),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'LE CONSTAT',
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
                      text: 'La santé mentale n\'est pas ',
                      style: AppText.serif(
                        size: isMobile ? 32 : 54,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: 'un luxe.',
                      style: AppText.serif(
                        size: isMobile ? 32 : 54,
                        style: FontStyle.italic,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Body
              Text(
                'Les troubles cognitifs et psychologiques touchent une personne sur cinq. Pourtant, l\'accès à une évaluation professionnelle reste réservé à ceux qui peuvent se payer une consultation spécialisée.',
                style: AppText.sans(
                  size: 16,
                  color: const Color(0xAAFFFFFF),
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 32),
              // Cards layout
              if (isMobile)
                const IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _PricingCard(),
                      SizedBox(height: 16),
                      _FreeCard(),
                    ],
                  ),
                )
              else
                const IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _PricingCard()),
                      SizedBox(width: 16),
                      Expanded(child: _FreeCard()),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  const _PricingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0x0FFFFFFF),
        border: Border.all(color: const Color(0x22FFFFFF)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0x1FE05252),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Center(
                  child: Text(
                    '\u20AC',
                    style: TextStyle(
                      color: Color(0xFFE05252),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'En France, un bilan neuropsychologique coûte entre',
                  style: AppText.sans(
                    size: 14,
                    color: const Color(0xCCFFFFFF),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '500 \u20AC – 1\u202f500 \u20AC',
            style: AppText.mono(
              size: 20,
              color: const Color(0xFFE05252),
              weight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'en cabinet privé — inaccessible pour beaucoup.',
            style: AppText.sans(
              size: 13,
              color: const Color(0x88FFFFFF),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _FreeCard extends StatelessWidget {
  const _FreeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0x0FFFFFFF),
        border: Border.all(color: const Color(0x22FFFFFF)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0x1F4D7C4A),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Center(
                  child: Text(
                    '✓',
                    style: TextStyle(
                      color: Color(0xFF4D7C4A),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Avec Mental E.T., l\'accès est entièrement',
                  style: AppText.sans(
                    size: 14,
                    color: const Color(0xCCFFFFFF),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '100% gratuit',
            style: AppText.mono(
              size: 20,
              color: AppColors.accent,
              weight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'pour toujours. Sans compromis.',
            style: AppText.sans(
              size: 13,
              color: const Color(0x88FFFFFF),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
