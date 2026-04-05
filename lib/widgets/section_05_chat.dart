import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class Section05Chat extends StatelessWidget {
  const Section05Chat({super.key, this.sectionKey});

  final GlobalKey? sectionKey;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      key: sectionKey,
      width: double.infinity,
      color: AppColors.darkBg,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 48 : 80,
        horizontal: isMobile ? 20 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: isMobile ? _buildMobile() : _buildDesktop(),
        ),
      ),
    );
  }

  Widget _buildMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),
        const SizedBox(height: 24),
        _buildHeading(false),
        const SizedBox(height: 24),
        _buildFeatures(),
        const SizedBox(height: 40),
        const _ChatCard(),
      ],
    );
  }

  Widget _buildDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(),
              const SizedBox(height: 24),
              _buildHeading(true),
              const SizedBox(height: 32),
              _buildFeatures(),
            ],
          ),
        ),
        const SizedBox(width: 64),
        const Expanded(child: _ChatCard()),
      ],
    );
  }

  Widget _buildLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x1A4D7C4A),
        border: Border.all(color: const Color(0x334D7C4A)),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        'ACCOMPAGNEMENT IA',
        style: AppText.mono(
          size: 11,
          color: AppColors.accent,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildHeading(bool isDesktop) {
    final size = isDesktop ? 54.0 : 32.0;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Un espace d\'écoute ',
            style: AppText.serif(size: size, color: Colors.white),
          ),
          TextSpan(
            text: 'disponible\n24h/24.',
            style: AppText.serif(
              size: size,
              style: FontStyle.italic,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _FeatureItem(
          title: 'Écoute active non directive',
          description:
              'L\'IA ne juge pas, ne prescrit pas, et ne remplace pas un professionnel.',
        ),
        SizedBox(height: 20),
        _FeatureItem(
          title: 'Confidentiel et sécurisé',
          description:
              'Vos échanges ne sont pas utilisés pour entraîner des modèles.',
        ),
        SizedBox(height: 20),
        _FeatureItem(
          title: 'Orienté vers le soin si nécessaire',
          description:
              'Si des signaux d\'alerte sont détectés, l\'IA vous oriente vers des ressources.',
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String title;
  final String description;

  const _FeatureItem({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '—',
              style: AppText.sans(
                size: 16,
                color: AppColors.accent,
                weight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: AppText.sans(
                size: 14,
                weight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            description,
            style: AppText.sans(
              size: 13,
              color: const Color(0x88FFFFFF),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatCard extends StatelessWidget {
  const _ChatCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Container(
        color: const Color(0xFF0D2318),
        child: Column(
          children: [
            // Header
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.accent,
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mentality',
                        style: AppText.sans(
                          size: 14,
                          weight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'En ligne',
                            style: AppText.sans(
                              size: 12,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Messages
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: const [
                  _AiBubble(
                    text:
                        'Bonjour. Vous venez de terminer vos tests cognitifs. Comment vous sentez-vous après cette expérience ?',
                  ),
                  SizedBox(height: 10),
                  _UserBubble(
                    text:
                        'Honnêtement, un peu surpris. Mon score IMT était plus bas que prévu.',
                  ),
                  SizedBox(height: 10),
                  _AiBubble(
                    text:
                        'C\'est tout à fait compréhensible. Découvrir quelque chose d\'inattendu sur soi peut être déstabilisant. Qu\'est-ce qui vous a le plus surpris ?',
                  ),
                  SizedBox(height: 10),
                  _UserBubble(
                    text:
                        'Je pensais être meilleur en mémorisation. Est-ce que ça veut dire que j\'ai un problème ?',
                  ),
                  SizedBox(height: 10),
                  _AiBubble(
                    text:
                        'Un score IMT plus bas ne signifie pas un problème — il révèle simplement une facette de votre fonctionnement cognitif, qui peut évoluer dans le temps.',
                  ),
                ],
              ),
            ),
            // Input bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0x22FFFFFF)),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Écrivez votre message...',
                        hintStyle: TextStyle(
                          color: Color(0x66FFFFFF),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.send,
                        color: Colors.white, size: 18),
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

class _AiBubble extends StatelessWidget {
  final String text;

  const _AiBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xFF1A3326),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: AppText.sans(size: 14, color: Colors.white, height: 1.5),
        ),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  final String text;

  const _UserBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          text,
          style: AppText.sans(size: 14, color: Colors.white, height: 1.5),
        ),
      ),
    );
  }
}
