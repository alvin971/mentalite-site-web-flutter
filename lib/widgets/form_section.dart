import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../services/supabase_service.dart';
import '../services/notification_service.dart';
import '../services/registration_storage.dart';

class FormSection extends StatefulWidget {
  final GlobalKey? sectionKey;

  const FormSection({super.key, this.sectionKey});

  @override
  State<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final _formKey = GlobalKey<FormState>();
  final _prenomCtrl = TextEditingController();
  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  String? _reseau;
  bool _termsAccepted = false;
  bool _loading = false;
  String? _errorMessage;

  static const _reseaux = [
    'TikTok',
    'Instagram',
    'YouTube',
    'Recommandation',
    'Autre',
  ];

  @override
  void dispose() {
    _prenomCtrl.dispose();
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted) {
      setState(() {
        _errorMessage = 'Vous devez accepter les conditions d\'utilisation.';
      });
      return;
    }

    setState(() => _loading = true);

    try {
      // Demander la permission notifications — timeout 8s, non bloquant
      String? fcmToken;
      try {
        fcmToken = await NotificationService.requestAndGetToken()
            .timeout(const Duration(seconds: 8));
      } catch (_) {
        // Notification refusée ou timeout — on continue sans token
      }

      final result = await submitInscription(
        prenom: _prenomCtrl.text.trim(),
        nom: _nomCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        telephone: _telCtrl.text.trim(),
        reseau: _reseau ?? '',
        fcmToken: fcmToken,
      );

      if (result.success) {
        await RegistrationStorage.save(
          prenom: _prenomCtrl.text.trim(),
          place: result.placeNumber ?? 0,
        );
        if (mounted) {
          context.go(
            '/confirmation?prenom=${Uri.encodeComponent(_prenomCtrl.text.trim())}&place=${result.placeNumber ?? 0}',
          );
        }
      } else {
        setState(() => _errorMessage = result.errorMessage);
      }
    } catch (_) {
      setState(() => _errorMessage = 'Une erreur est survenue. Veuillez réessayer.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      key: widget.sectionKey,
      width: double.infinity,
      color: AppColors.bg,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 48 : 80,
        horizontal: isMobile ? 20 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
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
                  'ACCÈS GRATUIT',
                  style: AppText.mono(
                    size: 11,
                    color: AppColors.accent,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // H2
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Réserver mon ',
                      style: AppText.serif(size: isMobile ? 32 : 54),
                    ),
                    TextSpan(
                      text: 'accès',
                      style: AppText.serif(
                        size: isMobile ? 32 : 54,
                        style: FontStyle.italic,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Inscription gratuite. Aucune carte bancaire requise.',
                style: AppText.sans(
                  size: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 36),
              Container(
                padding: EdgeInsets.all(isMobile ? 24 : 48),
                decoration: BoxDecoration(
                  color: AppColors.bgWhite,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 24,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Prenom + Nom
                      if (isMobile)
                        Column(
                          children: [
                            _FormField(
                              controller: _prenomCtrl,
                              label: 'Prénom',
                              hint: 'Jean',
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Requis'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            _FormField(
                              controller: _nomCtrl,
                              label: 'Nom',
                              hint: 'Dupont',
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Requis'
                                      : null,
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: _FormField(
                                controller: _prenomCtrl,
                                label: 'Prénom',
                                hint: 'Jean',
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Requis'
                                        : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _FormField(
                                controller: _nomCtrl,
                                label: 'Nom',
                                hint: 'Dupont',
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Requis'
                                        : null,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                      _FormField(
                        controller: _emailCtrl,
                        label: 'Adresse email',
                        hint: 'jean.dupont@email.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Requis';
                          if (!v.contains('@')) return 'Email invalide';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Phone field — optional
                      _FormField(
                        controller: _telCtrl,
                        label: 'Numéro de téléphone (optionnel)',
                        hint: '+33 6 12 34 56 78',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      // Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Comment avez-vous entendu parler de nous ?',
                            style: AppText.sans(
                              size: 13,
                              color: AppColors.textSecondary,
                              weight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _reseau,
                            hint: Text(
                              'Comment avez-vous entendu parler de nous ?',
                              style: AppText.sans(
                                  size: 14,
                                  color: AppColors.textTertiary),
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.accent, width: 1.5),
                              ),
                              filled: true,
                              fillColor: AppColors.bg,
                            ),
                            style: AppText.sans(
                                size: 15, color: AppColors.text),
                            items: _reseaux
                                .map((r) => DropdownMenuItem(
                                      value: r,
                                      child: Text(r),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _reseau = v);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Checkbox
                      GestureDetector(
                        onTap: () =>
                            setState(() => _termsAccepted = !_termsAccepted),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              margin: const EdgeInsets.only(top: 1),
                              decoration: BoxDecoration(
                                color: _termsAccepted
                                    ? AppColors.accent
                                    : AppColors.bgWhite,
                                border: Border.all(
                                  color: _termsAccepted
                                      ? AppColors.accent
                                      : AppColors.textTertiary,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: _termsAccepted
                                  ? const Icon(Icons.check,
                                      size: 12, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'J\'accepte les conditions d\'utilisation et la politique de confidentialité de Mental E.T.',
                                style: AppText.sans(
                                  size: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.danger.withValues(alpha: 0.07),
                            border: Border.all(
                                color: AppColors.danger
                                    .withValues(alpha: 0.3)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: AppText.sans(
                              size: 13,
                              color: AppColors.danger,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.bgWhite,
                            disabledBackgroundColor:
                                AppColors.accent.withValues(alpha: 0.6),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 0,
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Réserver ma place gratuite',
                                  style: AppText.sans(
                                    size: 15,
                                    weight: FontWeight.w600,
                                    color: AppColors.bgWhite,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // RGPD note with icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            size: 14,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Vos données sont protégées et ne seront jamais vendues. Conformément au RGPD, vous pouvez demander leur suppression à tout moment.',
                              style: AppText.sans(
                                size: 12,
                                color: AppColors.textTertiary,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.sans(
            size: 13,
            color: AppColors.textSecondary,
            weight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: AppText.sans(size: 15, color: AppColors.text),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                AppText.sans(size: 15, color: AppColors.textTertiary),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.accent, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.danger),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.danger, width: 1.5),
            ),
            filled: true,
            fillColor: AppColors.bg,
          ),
        ),
      ],
    );
  }
}
