import 'dart:convert';
import 'package:http/http.dart' as http;

const _supabaseUrl = 'https://supabase.0for0.com';
const _supabaseAnonKey =
    'eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9.eyJyb2xlIjogImFub24iLCAiaXNzIjogInN1cGFiYXNlIiwgImlhdCI6IDE3NzM5NjE0NTIsICJleHAiOiAyMDg5MzIxNDUyfQ.zU4lqg55i1aUG-SEIz_SeVCdMI5twUyqK4W1eyVMXYo';

Map<String, String> get _headers => {
      'apikey': _supabaseAnonKey,
      'Authorization': 'Bearer $_supabaseAnonKey',
      'Content-Type': 'application/json',
    };

class InscriptionResult {
  final bool success;
  final int? placeNumber;
  final String? errorMessage;

  InscriptionResult({required this.success, this.placeNumber, this.errorMessage});
}

Future<InscriptionResult> submitInscription({
  required String prenom,
  required String nom,
  required String email,
  required String telephone,
  required String reseau,
  String? fcmToken,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$_supabaseUrl/rest/v1/inscriptions'),
      headers: {..._headers, 'Prefer': 'return=representation'},
      body: jsonEncode({
        'prenom': prenom,
        'nom': nom,
        'email': email.toLowerCase(),
        'telephone': telephone,
        'reseau_social': reseau,
        'accepted_terms': true,
        if (fcmToken != null) 'fcm_token': fcmToken,
      }),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as List;
      final placeNumber = data[0]['place_number'] as int?;
      return InscriptionResult(success: true, placeNumber: placeNumber);
    } else if (response.statusCode == 409 || response.body.contains('23505')) {
      return InscriptionResult(
        success: false,
        errorMessage: 'Cette adresse email est déjà inscrite.',
      );
    } else {
      return InscriptionResult(
        success: false,
        errorMessage: 'Une erreur est survenue. Veuillez réessayer.',
      );
    }
  } catch (_) {
    return InscriptionResult(
      success: false,
      errorMessage: 'Impossible de se connecter. Vérifiez votre connexion.',
    );
  }
}

/// URL du Cloudflare Worker d'email (à remplacer après déploiement)
const _emailWorkerUrl = 'https://mental-et-email-confirmation.YOUR_SUBDOMAIN.workers.dev';

/// Envoie un email de confirmation post-inscription via Cloudflare Worker.
/// Non bloquant : les erreurs sont silencieuses pour ne pas pénaliser l'UX.
Future<void> sendConfirmationEmail({
  required String prenom,
  required String email,
  required int placeNumber,
}) async {
  if (_emailWorkerUrl.contains('YOUR_SUBDOMAIN')) return; // Worker non déployé
  try {
    await http.post(
      Uri.parse(_emailWorkerUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'prenom': prenom,
        'email': email,
        'place_number': placeNumber,
      }),
    ).timeout(const Duration(seconds: 10));
  } catch (_) {
    // Silencieux — l'email est un bonus, pas critique
  }
}

Future<int> fetchInscriptionCount() async {
  try {
    final response = await http.post(
      Uri.parse('$_supabaseUrl/rest/v1/rpc/get_inscription_count'),
      headers: _headers,
    ).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return int.tryParse(response.body.trim()) ?? 0;
    }
  } catch (_) {}
  return 0;
}
