import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:utsprojeck/controllers/cart_controller.dart';
import 'package:utsprojeck/models/product.dart';
import 'package:utsprojeck/screens/catalog_screen.dart';
import 'package:utsprojeck/services/product_catalog_service.dart';

void main() {
  final coffee = Product(id: 1, name: 'Kopi Susu', price: 15000);

  testWidgets('catalog products can be added and managed in the cart', (
    tester,
  ) async {
    final cart = CartController();
    addTearDown(cart.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: CatalogScreen(
          cartController: cart,
          loadProducts: () async => [coffee],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kopi Susu'), findsOneWidget);
    expect(find.text('Rp 15.000'), findsOneWidget);
    await tester.tap(find.byTooltip('Tambah Kopi Susu'));
    await tester.pump();
    expect(cart.itemCount, 1);

    await tester.tap(find.byTooltip('Buka keranjang'));
    await tester.pumpAndSettle();
    expect(find.text('Keranjang'), findsOneWidget);
    expect(find.text('Rp 15.000'), findsNWidgets(2));

    await tester.tap(find.byTooltip('Tambah Kopi Susu'));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Rp 30.000'), findsNWidgets(2));

    await tester.tap(find.byTooltip('Kurangi Kopi Susu'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Rp 15.000'), findsNWidgets(2));

    await tester.tap(find.byTooltip('Hapus Kopi Susu'));
    await tester.pump();
    expect(find.text('Keranjang masih kosong'), findsOneWidget);
    expect(cart.total, 0);
  });

  testWidgets('catalog displays a retry action when loading fails', (
    tester,
  ) async {
    final cart = CartController();
    addTearDown(cart.dispose);
    var attempts = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: CatalogScreen(
          cartController: cart,
          loadProducts: () async {
            attempts++;
            if (attempts == 1) {
              throw Exception('catalog unavailable');
            }
            return [coffee];
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Katalog produk gagal dimuat.'), findsOneWidget);
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();

    expect(find.text('Kopi Susu'), findsOneWidget);
  });

  testWidgets('catalog loads the configured local product JSON', (
    tester,
  ) async {
    final cart = CartController();
    addTearDown(cart.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: CatalogScreen(
          cartController: cart,
          loadProducts: ProductCatalogService.loadProducts,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kopi Susu'), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);
  });

  testWidgets('catalog adapts to narrow and wide layouts with long names', (
    tester,
  ) async {
    final cart = CartController();
    addTearDown(cart.dispose);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);

    final products = [
      Product(
        id: 2,
        name: 'Kopi Susu Gula Aren Kemasan Besar untuk Dibawa Pulang',
        price: 25000,
      ),
      ...List.generate(
        5,
        (index) => Product(
          id: index + 3,
          name: 'Produk ${index + 1}',
          price: 10000 + index,
        ),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: CatalogScreen(
          cartController: cart,
          loadProducts: () async => products,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(SliverGrid), findsOneWidget);

    tester.view.physicalSize = const Size(1000, 900);
    await tester.pump();
    await tester.pumpAndSettle();

    final grid = tester.widget<SliverGrid>(find.byType(SliverGrid));
    expect(
      (grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
          .crossAxisCount,
      3,
    );
    expect(tester.takeException(), isNull);
  });
}
