import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthStorage {
  static const _kUser = 'auth_user';
  static const _kToken = 'auth_token';

  static Future<SharedPreferences> get _prefs =>
      SharedPreferences.getInstance();

  static Future<void> saveLogin({
    required Map<String, dynamic> user,
    required String token,
  }) async {
    final p = await _prefs;
    await p.setString(_kUser, jsonEncode(user));
    await p.setString(_kToken, token);
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final p = await _prefs;
    final json = p.getString(_kUser);
    return json == null ? null : jsonDecode(json);
  }

  static Future<String?> getToken() async {
    final p = await _prefs;
    return p.getString(_kToken);
  }

  static Future<void> clear() async {
    final p = await _prefs;
    await p.remove(_kUser);
    await p.remove(_kToken);
  }
}
