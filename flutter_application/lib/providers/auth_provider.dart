import 'package:flutter/material.dart';
import '../services/auth_storage.dart';

class AuthProvider extends ChangeNotifier{
  bool _isLoggedIn = false;
  Map<String, dynamic>? _user;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get user => _user;
  String? get token => _token;

  AuthProvider() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    _user = await AuthStorage.getUser();
    _token = await AuthStorage.getToken();
    _isLoggedIn = _user != null && _token != null;
    notifyListeners();
  }

  Future<void> login(Map<String, dynamic> user, String token) async {
    await AuthStorage.saveLogin(user: user, token: token);
    _user = user;
    _token = token;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthStorage.clear();
    _user = null;
    _token = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}