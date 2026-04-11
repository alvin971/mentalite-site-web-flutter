import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class ConfidentialitePage extends StatelessWidget {
  const ConfidentialitePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Politique de confidentialité',
          style: AppText.sans(size: 16, weight: FontWeight.w600, color: AppColors.text),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 48,
          horizontal: isMobile ? 20 : 48,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Politique de confidentialité',
                  style: AppText.serif(size: isMobile ? 32 : 44),
                ),
                const SizedBox(height: 8),
                Text(
                  'Dernière mise à jour : avril 2025',
                  style: AppText.sans(size: 13, color: AppColors.textTertiary),
                ),
                const SizedBox(height: 40),

                _Section(
                  title: '1. Responsable du traitement',
                  body: 'Mental E.T. est responsable du traitement de vos données personnelles collectées via ce site.\n\nContact : contact@mental-et.fr',
                ),

                _Section(
                  title: '2. Données collectées',
                  body: 'Dans le cadre de votre inscription sur la liste d\'attente, nous collectons les données suivantes :\n\n'
                      '• Prénom et nom de famille\n'
                      '• Adresse email\n'
                      '• Numéro de téléphone (optionnel)\n'
                      '• Réseau social par lequel vous avez découvert Mental E.T. (optionnel)\n'
                      '• Token de notification Firebase Cloud Messaging (FCM), si vous avez accepté les notifications push\n'
                      '• Numéro de place dans la liste d\'attente\n'
                      '• Date et heure d\'inscription',
                ),

                _Section(
                  title: '3. Finalité du traitement',
                  body: 'Vos données sont collectées exclusivement pour :\n\n'
                      '• Vous inscrire sur la liste d\'attente prioritaire de Mental E.T.\n'
                      '• Vous notifier lors du lancement de la plateforme (par email et/ou notification push)\n'
                      '• Calculer et vous attribuer un numéro de place dans la file d\'attente\n\n'
                      'Vos données ne sont pas utilisées à des fins publicitaires, commerciales ou de profilage.',
                ),

                _Section(
                  title: '4. Base légale',
                  body: 'Le traitement de vos données repose sur votre consentement explicite, donné lors de la validation du formulaire d\'inscription (case à cocher obligatoire).',
                ),

                _Section(
                  title: '5. Destinataires des données',
                  body: 'Vos données sont hébergées sur une infrastructure Supabase auto-hébergée sur un serveur localisé en France.\n\n'
                      'Elles ne sont transmises à aucun tiers à des fins commerciales. Les seuls accès sont :\n\n'
                      '• L\'équipe interne de Mental E.T. (administration de la liste d\'attente)\n'
                      '• Firebase Cloud Messaging (Google) pour les notifications push — uniquement si vous avez accordé cette permission\n'
                      '• Resend (service d\'email transactionnel) pour l\'envoi de l\'email de confirmation',
                ),

                _Section(
                  title: '6. Durée de conservation',
                  body: 'Vos données sont conservées jusqu\'au lancement public de la plateforme Mental E.T., puis pendant une durée maximale de 12 mois après ce lancement.\n\n'
                      'Passé ce délai, ou suite à votre demande, vos données seront supprimées.',
                ),

                _Section(
                  title: '7. Vos droits',
                  body: 'Conformément au Règlement Général sur la Protection des Données (RGPD — Règlement UE 2016/679), vous disposez des droits suivants :\n\n'
                      '• Droit d\'accès : obtenir une copie de vos données\n'
                      '• Droit de rectification : corriger des données inexactes\n'
                      '• Droit à l\'effacement : demander la suppression de vos données\n'
                      '• Droit à la limitation : restreindre le traitement dans certains cas\n'
                      '• Droit d\'opposition : vous opposer au traitement\n\n'
                      'Pour exercer ces droits, contactez-nous à : contact@mental-et.fr\n\n'
                      'Vous pouvez également introduire une réclamation auprès de la CNIL (www.cnil.fr).',
                ),

                _Section(
                  title: '8. Sécurité',
                  body: 'Vos données sont protégées par :\n\n'
                      '• Connexion chiffrée HTTPS (TLS 1.3)\n'
                      '• Accès à la base de données restreint par des politiques Row Level Security (RLS)\n'
                      '• Serveur hébergé en France, accès restreint à l\'équipe interne',
                ),

                _Section(
                  title: '9. Cookies',
                  body: 'Mental E.T. n\'utilise aucun cookie de traçage ni cookie publicitaire.\n\n'
                      'L\'application Flutter Web peut utiliser le stockage local du navigateur (localStorage / IndexedDB) pour mémoriser votre inscription sur cet appareil, afin d\'éviter une double inscription. Ces données ne quittent pas votre appareil.',
                ),

                _Section(
                  title: '10. Modifications',
                  body: 'Cette politique peut être mise à jour. En cas de modification substantielle, vous serez notifié par email si vous êtes inscrit sur la liste d\'attente.',
                ),

                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accentDim,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.mail_outline, size: 18, color: AppColors.accent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Pour toute question relative à vos données personnelles : contact@mental-et.fr',
                          style: AppText.sans(size: 14, color: AppColors.text, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;

  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppText.sans(
              size: 17,
              weight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: AppText.sans(
              size: 14,
              color: AppColors.textSecondary,
              height: 1.75,
            ),
          ),
        ],
      ),
    );
  }
}
