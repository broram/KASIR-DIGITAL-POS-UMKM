import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utsprojeck/controllers/cart_controller.dart';
import 'package:utsprojeck/models/product.dart';
import 'package:utsprojeck/screens/cart_screen.dart';
import 'package:utsprojeck/screens/payment_screen.dart';

void main() {
  final coffee = Product(id: 1, name: 'Kopi Susu', price: 15000);

  testWidgets('checkout is disabled when the cart is empty', (tester) async {
    final cart = CartController();
    addTearDown(cart.dispose);

    await tester.pumpWidget(
      MaterialApp(home: CartScreen(cartController: cart)),
    );

    final checkoutButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Lanjutkan pembayaran'),
    );
    expect(checkoutButton.onPressed, isNull);
  });

  testWidgets('long product names stay within a narrow cart layout', (
    tester,
  ) async {
    final cart = CartController();
    addTearDown(cart.dispose);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);

    final longNameProduct = Product(
      id: 2,
      name:
          'Kopi Susu Gula Aren Kemasan Besar untuk Dibawa Pulang Tanpa Tumpah',
      price: 25000,
    );
    cart.add(longNameProduct);
    for (var index = 0; index < 12; index++) {
      cart.add(
        Product(
          id: index + 3,
          name: 'Produk Kasir ${index + 1}',
          price: 5000 + index * 1000,
        ),
      );
    }

    await tester.pumpWidget(
      MaterialApp(home: CartScreen(cartController: cart)),
    );
    await tester.pumpAndSettle();

    expect(cart.items, hasLength(13));
    expect(tester.takeException(), isNull);
    expect(find.text(longNameProduct.name), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -1800));
    await tester.pumpAndSettle();
    expect(find.text('Produk Kasir 12'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('payment validates amount and completes a confirmed sale', (
    tester,
  ) async {
    final cart = CartController()..add(coffee);
    addTearDown(cart.dispose);

    await tester.pumpWidget(
      MaterialApp(home: PaymentScreen(cartController: cart)),
    );

    await tester.tap(find.text('Bayar dan selesaikan'));
    await tester.pumpAndSettle();
    expect(find.text('Masukkan nominal pembayaran.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '10000');
    await tester.tap(find.text('Bayar dan selesaikan'));
    await tester.pumpAndSettle();
    expect(find.text('Pembayaran kurang Rp 5.000.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '20000');
    await tester.pump();
    expect(find.text('Rp 5.000'), findsOneWidget);
    await tester.tap(find.text('Bayar dan selesaikan'));
    await tester.pumpAndSettle();

    expect(find.text('Konfirmasi transaksi'), findsOneWidget);
    await tester.tap(find.text('Konfirmasi'));
    await tester.pumpAndSettle();

    expect(find.text('Transaksi berhasil'), findsOneWidget);
    expect(find.text('Kopi Susu'), findsOneWidget);
    expect(find.text('1 x Rp 15.000'), findsOneWidget);
    expect(find.text('Uang diterima'), findsOneWidget);
    expect(cart.items, isEmpty);
    expect(cart.total, 0);
  });

  testWidgets('canceling confirmation keeps the cart unchanged', (
    tester,
  ) async {
    final cart = CartController()..add(coffee);
    addTearDown(cart.dispose);

    await tester.pumpWidget(
      MaterialApp(home: PaymentScreen(cartController: cart)),
    );
    await tester.enterText(find.byType(TextFormField), '20000');
    await tester.tap(find.text('Bayar dan selesaikan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Periksa lagi'));
    await tester.pumpAndSettle();

    expect(cart.total, 15000);
    expect(cart.items, hasLength(1));
    expect(find.text('Transaksi berhasil'), findsNothing);
  });
}
