import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      color: AppColors.footerBg,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile ? 20 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FooterBrand(),
                    const SizedBox(height: 36),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _FooterCol(
                          title: 'Plateforme',
                          links: [
                            ('Les tests cognitifs', null),
                            ('Accompagnement IA', null),
                            ('Accès anticipé', null),
                          ],
                        )),
                        Expanded(child: _FooterCol(
                          title: 'Légal',
                          links: [
                            ('Confidentialité', null),
                            ('CGU', null),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _FooterCol(
                          title: 'Contact',
                          links: [
                            ('Contact', null),
                            ('Cliniciens', null),
                          ],
                        )),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _FooterBrand()),
                    Expanded(child: _FooterCol(
                      title: 'Plateforme',
                      links: [
                        ('Les tests cognitifs', null),
                        ('Accompagnement IA', null),
                        ('Accès anticipé', null),
                      ],
                    )),
                    Expanded(child: _FooterCol(
                      title: 'Légal',
                      links: [
                        ('Confidentialité', null),
                        ('CGU', null),
                      ],
                    )),
                    Expanded(child: _FooterCol(
                      title: 'Contact',
                      links: [
                        ('Contact', null),
                        ('Cliniciens', null),
                      ],
                    )),
                  ],
                ),
              const SizedBox(height: 48),
              Container(
                height: 1,
                color: AppColors.footerMuted.withValues(alpha: 0.15),
              ),
              const SizedBox(height: 24),
              Text(
                '© 2025 Mental E.T. Tous droits réservés.',
                style: AppText.sans(size: 13, color: AppColors.footerMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mental E.T.',
          style: AppText.serif(
            size: 22,
            color: AppColors.footerText,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'La première plateforme de psychologie complète et gratuite.',
          style: AppText.sans(
            size: 14,
            color: AppColors.footerMuted,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.footerMuted.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            'Supervisé par des psychiatres et psychologues · Non substitut au soin médical',
            style: AppText.sans(size: 11, color: AppColors.footerMuted),
          ),
        ),
      ],
    );
  }
}

class _FooterCol extends StatelessWidget {
  final String title;
  final List<(String, String?)> links;

  const _FooterCol({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppText.sans(
            size: 12,
            weight: FontWeight.w600,
            color: AppColors.footerText,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map((link) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                link.$1,
                style: AppText.sans(size: 14, color: AppColors.footerMuted),
              ),
            )),
      ],
    );
  }
}
