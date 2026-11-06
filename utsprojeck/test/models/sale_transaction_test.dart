import 'package:flutter_test/flutter_test.dart';
import 'package:utsprojeck/models/cart_item.dart';
import 'package:utsprojeck/models/product.dart';
import 'package:utsprojeck/models/sale_transaction.dart';

void main() {
  final product = Product(
    id: 1,
    name: 'Kopi',
    price: 12000,
    imageUrl: 'https://example.com/kopi.png',
  );

  test('product JSON maps the agreed catalog fields', () {
    final decoded = Product.fromJson(product.toJson());

    expect(decoded.id, 1);
    expect(decoded.name, 'Kopi');
    expect(decoded.price, 12000);
    expect(decoded.imageUrl, 'https://example.com/kopi.png');
  });

  test('cart item calculates subtotal', () {
    final item = CartItem(product: product, quantity: 2);

    expect(item.subtotal, 24000);
    expect(item.toJson()['subtotal'], 24000);
  });

  test('transaction calculates total and change from its items', () {
    final transaction = SaleTransaction(
      id: 'TRX-001',
      createdAt: DateTime(2026, 10, 25),
      items: [CartItem(product: product, quantity: 2)],
      amountPaid: 30000,
    );

    expect(transaction.total, 24000);
    expect(transaction.change, 6000);
    expect(transaction.toJson()['total'], 24000);
  });

  test('transaction rejects empty items and insufficient payment', () {
    expect(
      () => SaleTransaction(
        id: 'TRX-002',
        createdAt: DateTime(2026, 10, 25),
        items: const [],
        amountPaid: 0,
      ),
      throwsArgumentError,
    );
    expect(
      () => SaleTransaction(
        id: 'TRX-003',
        createdAt: DateTime(2026, 10, 25),
        items: [CartItem(product: product)],
        amountPaid: 0,
      ),
      throwsArgumentError,
    );
  });

  test('product and cart item reject invalid values', () {
    expect(() => Product(id: 2, name: '   ', price: 1000), throwsArgumentError);
    expect(
      () => Product(id: 2, name: 'Teh', price: -1000),
      throwsArgumentError,
    );
    expect(() => CartItem(product: product, quantity: 0), throwsArgumentError);
  });
}
