import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utsprojeck/controllers/cashier_auth_controller.dart';
import 'package:utsprojeck/screens/login_screen.dart';
import 'package:utsprojeck/services/cashier_auth_service.dart';

void main() {
  test('cashier can register, log in, and log out', () async {
    final service = _FakeCashierAuthService();
    final controller = CashierAuthController(authService: service);

    await controller.initialize();
    expect(controller.registeredCashier, isNull);
    expect(controller.isLoggedIn, isFalse);

    await controller.register(name: 'Ramdan', pin: '1234');
    expect(controller.registeredCashier, 'Ramdan');
    expect(controller.cashierName, 'Ramdan');
    expect(controller.isLoggedIn, isTrue);

    controller.logout();
    expect(controller.isLoggedIn, isFalse);
    expect(controller.cashierName, isNull);

    expect(await controller.login(name: 'ramdan', pin: '0000'), isFalse);
    expect(await controller.login(name: 'ramdan', pin: '1234'), isTrue);
    expect(controller.cashierName, 'Ramdan');

    controller.dispose();
  });

  testWidgets(
    'first launch creates the cashier profile before entering the app',
    (tester) async {
      final controller = CashierAuthController(
        authService: _FakeCashierAuthService(),
      );
      await controller.initialize();

      await tester.pumpWidget(
        MaterialApp(home: LoginScreen(authController: controller)),
      );
      expect(
        tester
            .widget<TextFormField>(find.byKey(const Key('cashier-name')))
            .controller
            ?.text,
        'Ramdan',
      );

      await tester.enterText(find.byKey(const Key('cashier-pin')), '2468');
      await tester.enterText(
        find.byKey(const Key('cashier-pin-confirm')),
        '2468',
      );
      await tester.ensureVisible(find.text('Buat profil dan masuk'));
      await tester.tap(find.text('Buat profil dan masuk'));
      await tester.pumpAndSettle();

      expect(controller.isLoggedIn, isTrue);
      expect(controller.cashierName, 'Ramdan');
      controller.dispose();
    },
  );

  testWidgets('wrong PIN is rejected without opening a cashier session', (
    tester,
  ) async {
    final service = _FakeCashierAuthService();
    await service.register(name: 'Ramdan', pin: '2468');
    final controller = CashierAuthController(authService: service);
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(home: LoginScreen(authController: controller)),
    );
    await tester.enterText(find.byKey(const Key('cashier-pin')), '0000');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Nama kasir atau PIN tidak sesuai.'), findsOneWidget);
    expect(controller.isLoggedIn, isFalse);
    controller.dispose();
  });
}

class _FakeCashierAuthService implements CashierAuthService {
  String? _name;
  String? _pin;

  @override
  Future<String?> getRegisteredCashier() async => _name;

  @override
  Future<void> register({required String name, required String pin}) async {
    _name = name;
    _pin = pin;
  }

  @override
  Future<bool> authenticate({required String name, required String pin}) async {
    return name.trim().toLowerCase() == _name?.toLowerCase() && pin == _pin;
  }
}
