import 'package:flutter/foundation.dart';

import '../services/cashier_auth_service.dart';

class CashierAuthController extends ChangeNotifier {
  CashierAuthController({required this.authService});

  final CashierAuthService authService;

  String? _registeredCashier;
  String? _cashierName;
  bool _isLoggedIn = false;

  /// Mengembalikan nama kasir yang sudah terdaftar, atau null jika belum ada.
  String? get registeredCashier => _registeredCashier;

  /// Mengembalikan nama kasir yang sedang login.
  String? get cashierName => _cashierName;

  /// Menyatakan apakah saat ini ada kasir yang sudah login.
  bool get isLoggedIn => _isLoggedIn;

  /// Memuat data kasir terdaftar dan mengosongkan status login awal.
  Future<void> initialize() async {
    _registeredCashier = await authService.getRegisteredCashier();
    notifyListeners();
  }

  /// Mendaftarkan kasir baru melalui service autentikasi lokal.
  Future<void> register({required String name, required String pin}) async {
    await authService.register(name: name, pin: pin);
    _registeredCashier = name.trim();
    _cashierName = _registeredCashier;
    _isLoggedIn = true;
    notifyListeners();
  }

  /// Memvalidasi nama dan PIN kasir, lalu menyimpan sesi login jika berhasil.
  Future<bool> login({required String name, required String pin}) async {
    final authenticated = await authService.authenticate(name: name, pin: pin);
    if (!authenticated) return false;

    _cashierName = _registeredCashier;
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  /// Menghapus status login kasir saat ini.
  void logout() {
    _cashierName = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
