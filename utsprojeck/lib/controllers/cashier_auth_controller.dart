import 'package:flutter/foundation.dart';

import '../services/cashier_auth_service.dart';

class CashierAuthController extends ChangeNotifier {
  CashierAuthController({required this.authService});

  final CashierAuthService authService;

  String? _registeredCashier;
  String? _cashierName;
  bool _isLoggedIn = false;

  String? get registeredCashier => _registeredCashier;
  String? get cashierName => _cashierName;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> initialize() async {
    _registeredCashier = await authService.getRegisteredCashier();
    notifyListeners();
  }

  Future<void> register({required String name, required String pin}) async {
    await authService.register(name: name, pin: pin);
    _registeredCashier = name.trim();
    _cashierName = _registeredCashier;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<bool> login({required String name, required String pin}) async {
    final authenticated = await authService.authenticate(name: name, pin: pin);
    if (!authenticated) return false;

    _cashierName = _registeredCashier;
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  void logout() {
    _cashierName = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
