import 'package:flutter_test/flutter_test.dart';
import 'package:utsprojeck/services/cashier_auth_service.dart';

void main() {
  test('local auth stores a salted hash and verifies the PIN', () async {
    final storage = _MemoryCashierCredentialStorage();
    final service = LocalCashierAuthService(storage: storage);

    await service.register(name: 'Ramdan', pin: '2468');

    expect(await service.getRegisteredCashier(), 'Ramdan');
    expect(storage.values['cashier.pin_salt'], isNotEmpty);
    expect(storage.values['cashier.pin_hash'], isNot('2468'));
    expect(await service.authenticate(name: 'ramdan', pin: '2468'), isTrue);
    expect(await service.authenticate(name: 'Ramdan', pin: '0000'), isFalse);
    expect(
      await service.authenticate(name: 'Kasir lain', pin: '2468'),
      isFalse,
    );
  });
}

class _MemoryCashierCredentialStorage implements CashierCredentialStorage {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }
}
