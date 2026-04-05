import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class ConfirmationPage extends StatelessWidget {
  final String prenom;
  final int place;

  const ConfirmationPage({
    super.key,
    required this.prenom,
    required this.place,
  });

  String get _placeFormatted => '#${place.toString().padLeft(4, '0')}';

  String get _shareUrl =>
      'https://mentalite-site-web.pages.dev/?ref=${Uri.encodeComponent(prenom.toLowerCase())}';

  String get _tiktokShareUrl =>
      'https://www.tiktok.com/share?url=${Uri.encodeComponent(_shareUrl)}&text=${Uri.encodeComponent("Je viens de réserver ma place sur Mentality, la première plateforme de psychologie gratuite ! $prenom")}';

  Future<void> _copyLink(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _shareUrl));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lien copié dans le presse-papier',
            style: AppText.sans(size: 14, color: Colors.white),
          ),
          backgroundColor: AppColors.accent,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }
  }

  Future<void> _shareTikTok() async {
    final uri = Uri.parse(_tiktokShareUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          // Simple navbar
          Container(
            color: AppColors.bg,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 48,
              vertical: 16,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Text(
                    'Mentality',
                    style: AppText.serif(
                      size: 20,
                      weight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'Accès anticipé',
                      style: AppText.sans(
                          size: 11,
                          color: AppColors.accent,
                          weight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 48,
                      vertical: isMobile ? 40 : 80,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Status pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: AppColors.success.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Inscription confirmée',
                                style: AppText.sans(
                                  size: 13,
                                  color: AppColors.success,
                                  weight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        // H1
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Bonjour ${prenom.isNotEmpty ? prenom : 'vous'},',
                                style: AppText.serif(
                                    size: isMobile ? 32 : 42),
                              ),
                              const TextSpan(text: '\n'),
                              TextSpan(
                                text: 'votre place est réservée.',
                                style: AppText.serif(
                                  size: isMobile ? 32 : 42,
                                  style: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Vous serez parmi les premiers à accéder à Mentality lors du lancement. Nous vous contacterons par email.',
                          style: AppText.sans(
                            size: 16,
                            color: AppColors.textSecondary,
                            height: 1.7,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 36),
                        // Place card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: AppColors.bgWhite,
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Votre numéro de place',
                                style: AppText.sans(
                                  size: 13,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _placeFormatted,
                                style: AppText.serif(
                                  size: 52,
                                  weight: FontWeight.w700,
                                  color: AppColors.accent,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Accès anticipé · Mentality',
                                style: AppText.sans(
                                  size: 12,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Action buttons
                        if (isMobile)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _TikTokButton(onTap: _shareTikTok),
                              const SizedBox(height: 12),
                              _CopyButton(onTap: () => _copyLink(context)),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: _TikTokButton(onTap: _shareTikTok),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _CopyButton(
                                    onTap: () => _copyLink(context)),
                              ),
                            ],
                          ),
                        const SizedBox(height: 48),
                        // Simple footer
                        Text(
                          '© 2025 Mentality. Supervisé par des psychiatres et psychologues.',
                          style: AppText.sans(
                            size: 12,
                            color: AppColors.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TikTokButton extends StatelessWidget {
  final VoidCallback onTap;

  const _TikTokButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF010101),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.share, size: 16),
          const SizedBox(width: 8),
          Text(
            'Partager sur TikTok',
            style: AppText.sans(
              size: 14,
              weight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CopyButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.copy, size: 16),
          const SizedBox(width: 8),
          Text(
            'Copier le lien',
            style: AppText.sans(
              size: 14,
              weight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
