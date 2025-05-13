import 'package:flutter/foundation.dart';

class AuthService with ChangeNotifier {
  bool _authenticated = false;
  bool get isAuthenticated => _authenticated;

  Future<void> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (username.trim() == 'test' && password.trim() == 'test2023') {
      _authenticated = true;
      notifyListeners();
    } else {
      throw Exception('Usuario o contraseña inválidos');
    }
  }

  void logout() {
    _authenticated = false;
    notifyListeners();
  }
}
