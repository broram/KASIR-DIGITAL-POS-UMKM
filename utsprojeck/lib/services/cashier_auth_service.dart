import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class CashierCredentialStorage {
  /// Membaca nilai dari penyimpanan aman berdasarkan kunci.
  Future<String?> read(String key);

  /// Menyimpan nilai ke penyimpanan aman berdasarkan kunci.
  Future<void> write(String key, String value);
}

abstract interface class CashierAuthService {
  /// Mengambil nama kasir yang terdaftar.
  Future<String?> getRegisteredCashier();

  /// Mendaftarkan nama dan PIN kasir.
  Future<void> register({required String name, required String pin});

  /// Memeriksa kecocokan nama dan PIN kasir.
  Future<bool> authenticate({required String name, required String pin});
}

class LocalCashierAuthService implements CashierAuthService {
  LocalCashierAuthService({CashierCredentialStorage? storage})
    : _storage =
          storage ?? _FlutterSecureCashierStorage(const FlutterSecureStorage());

  static const _cashierNameKey = 'cashier.name';
  static const _pinSaltKey = 'cashier.pin_salt';
  static const _pinHashKey = 'cashier.pin_hash';

  static final _pinHasher = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 256,
  );

  final CashierCredentialStorage _storage;

  @override
  /// Membaca profil kasir dan memastikan data kredensial lengkap.
  Future<String?> getRegisteredCashier() async {
    try {
      final name = await _storage.read(_cashierNameKey);
      if (name == null) return null;

      final salt = await _storage.read(_pinSaltKey);
      final hash = await _storage.read(_pinHashKey);
      if (salt == null || hash == null) {
        throw const CashierAuthException(
          'Data login kasir tidak lengkap. Hapus data aplikasi untuk mengatur ulang.',
        );
      }
      return name;
    } on PlatformException {
      throw const CashierAuthException(
        'Data login kasir tidak dapat dibaca dari penyimpanan aman.',
      );
    }
  }

  @override
  /// Membuat salt acak, menghasilkan hash PIN, lalu menyimpan profil kasir.
  Future<void> register({required String name, required String pin}) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw const CashierAuthException('Nama kasir wajib diisi.');
    }
    if (!_isValidPin(pin)) {
      throw const CashierAuthException('PIN harus terdiri dari 4–6 digit.');
    }

    final salt = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    final hash = await _hashPin(pin, salt);

    try {
      await _storage.write(_pinSaltKey, base64Encode(salt));
      await _storage.write(_pinHashKey, base64Encode(hash));
      await _storage.write(_cashierNameKey, normalizedName);
    } on PlatformException {
      throw const CashierAuthException(
        'Profil kasir tidak dapat disimpan di penyimpanan aman.',
      );
    }
  }

  @override
  /// Membandingkan nama dan hash PIN untuk melakukan autentikasi kasir.
  Future<bool> authenticate({required String name, required String pin}) async {
    final storedName = await getRegisteredCashier();
    if (storedName == null ||
        storedName.toLowerCase() != name.trim().toLowerCase() ||
        !_isValidPin(pin)) {
      return false;
    }

    final saltValue = await _storage.read(_pinSaltKey);
    final hashValue = await _storage.read(_pinHashKey);
    if (saltValue == null || hashValue == null) {
      throw const CashierAuthException(
        'Data login kasir tidak lengkap. Hapus data aplikasi untuk mengatur ulang.',
      );
    }

    late final List<int> salt;
    late final List<int> expectedHash;
    try {
      salt = base64Decode(saltValue);
      expectedHash = base64Decode(hashValue);
    } on FormatException {
      throw const CashierAuthException(
        'Data PIN tersimpan tidak valid. Hapus data aplikasi untuk mengatur ulang.',
      );
    }
    final actualHash = await _hashPin(pin, salt);
    return _constantTimeEquals(expectedHash, actualHash);
  }

  /// Membuat hash PIN yang aman menggunakan PBKDF2 dan salt acak.
  Future<List<int>> _hashPin(String pin, List<int> salt) async {
    final key = await _pinHasher.deriveKey(
      secretKey: SecretKey(utf8.encode(pin)),
      nonce: salt,
    );
    return key.extractBytes();
  }

  /// Memastikan PIN hanya terdiri dari 4 sampai 6 digit angka.
  bool _isValidPin(String pin) => RegExp(r'^\d{4,6}$').hasMatch(pin);

  /// Membandingkan dua hash dengan waktu komputasi yang konsisten.
  bool _constantTimeEquals(List<int> first, List<int> second) {
    if (first.length != second.length) return false;
    var difference = 0;
    for (var index = 0; index < first.length; index++) {
      difference |= first[index] ^ second[index];
    }
    return difference == 0;
  }
}

class _FlutterSecureCashierStorage implements CashierCredentialStorage {
  /// Membungkus penyimpanan aman Flutter untuk kebutuhan autentikasi.
  const _FlutterSecureCashierStorage(this._storage);

  final FlutterSecureStorage _storage;

  @override
  /// Membaca satu data berdasarkan kunci dari penyimpanan aman.
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  /// Menulis satu data berdasarkan kunci ke penyimpanan aman.
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);
}

class CashierAuthException implements Exception {
  const CashierAuthException(this.message);

  final String message;
}
