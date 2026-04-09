import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  /// Demande la permission notifications iOS et retourne le token FCM.
  /// Retourne null si l'utilisateur refuse.
  static Future<String?> requestAndGetToken() async {
    try {
      final messaging = FirebaseMessaging.instance;

      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      ).timeout(const Duration(seconds: 5));

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        return await messaging.getToken()
            .timeout(const Duration(seconds: 5));
      }
    } catch (_) {
      // Timeout ou erreur Firebase — retourne null
    }
    return null;
  }
}
