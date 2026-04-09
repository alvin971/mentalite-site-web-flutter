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
    );

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

Future<int> fetchInscriptionCount() async {
  try {
    final response = await http.post(
      Uri.parse('$_supabaseUrl/rest/v1/rpc/get_inscription_count'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return int.tryParse(response.body.trim()) ?? 1200;
    }
  } catch (_) {}
  return 1200;
}
