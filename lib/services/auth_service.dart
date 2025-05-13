// lib/services/auth_service.dart
import 'package:flutter/foundation.dart';

class AuthService with ChangeNotifier {
  bool _authenticated = false;
  bool get isAuthenticated => _authenticated;

  /// Simula autenticación local.
  Future<void> login(String username, String password) async {
    // Retraso para simular petición de red
    await Future.delayed(const Duration(milliseconds: 500));

    if (username.trim() == 'test' && password.trim() == 'test2023') {
      _authenticated = true;
      notifyListeners();
    } else {
      throw Exception('Usuario o contraseña inválidos');
    }
  }

  /// Cierra sesión
  void logout() {
    _authenticated = false;
    notifyListeners();
  }
}
