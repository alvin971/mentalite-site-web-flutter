import 'package:shared_preferences/shared_preferences.dart';

class RegistrationStorage {
  static const _keyRegistered = 'is_registered';
  static const _keyPrenom = 'reg_prenom';
  static const _keyPlace = 'reg_place';

  /// Retourne true si l'utilisateur est déjà inscrit sur cet appareil.
  static Future<bool> isRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRegistered) ?? false;
  }

  /// Sauvegarde l'inscription après succès.
  static Future<void> save({required String prenom, required int place}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRegistered, true);
    await prefs.setString(_keyPrenom, prenom);
    await prefs.setInt(_keyPlace, place);
  }

  /// Récupère les données sauvegardées pour afficher la page de confirmation.
  static Future<({String prenom, int place})?> getSaved() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_keyRegistered) ?? false)) return null;
    return (
      prenom: prefs.getString(_keyPrenom) ?? '',
      place: prefs.getInt(_keyPlace) ?? 0,
    );
  }
}
