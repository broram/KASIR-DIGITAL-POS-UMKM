import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:utsprojeck/models/cart_item.dart';
import 'package:utsprojeck/models/product.dart';
import 'package:utsprojeck/models/sale_transaction.dart';
import 'package:utsprojeck/services/transaction_history_service.dart';

void main() {
  late Directory temporaryDirectory;
  late String databasePath;

  setUpAll(sqfliteFfiInit);
  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'kasir-history-test-',
    );
    databasePath = path.join(temporaryDirectory.path, 'transactions.db');
  });
  tearDown(() => temporaryDirectory.delete(recursive: true));

  test(
    'saved transactions and item snapshots survive reopening the database',
    () async {
      final transaction = SaleTransaction(
        id: 'TRX-001',
        createdAt: DateTime(2026, 11, 15, 10, 30),
        cashierName: 'Ramdan',
        items: [
          CartItem(
            product: Product(
              id: 3,
              name: 'Roti Bakar',
              price: 18000,
              imageUrl: 'assets/roti.png',
            ),
            quantity: 2,
          ),
        ],
        amountPaid: 40000,
      );
      final firstService = TransactionHistoryService(
        databaseFactory: databaseFactoryFfi,
        databasePath: databasePath,
      );

      await firstService.save(transaction);
      await firstService.close();

      final reopenedService = TransactionHistoryService(
        databaseFactory: databaseFactoryFfi,
        databasePath: databasePath,
      );
      final history = await reopenedService.loadAll();
      await reopenedService.close();

      expect(history, hasLength(1));
      expect(history.single.id, transaction.id);
      expect(history.single.cashierName, 'Ramdan');
      expect(history.single.total, 36000);
      expect(history.single.amountPaid, 40000);
      expect(history.single.change, 4000);
      expect(history.single.items.single.product.name, 'Roti Bakar');
      expect(history.single.items.single.product.imageUrl, 'assets/roti.png');
      expect(history.single.items.single.quantity, 2);
    },
  );

  test('a failed duplicate save does not add a partial transaction', () async {
    final service = TransactionHistoryService(
      databaseFactory: databaseFactoryFfi,
      databasePath: databasePath,
    );
    final transaction = SaleTransaction(
      id: 'TRX-DUPLICATE',
      createdAt: DateTime(2026, 11, 15),
      cashierName: 'Ramdan',
      items: [CartItem(product: Product(id: 1, name: 'Kopi', price: 15000))],
      amountPaid: 15000,
    );

    await service.save(transaction);
    await expectLater(
      service.save(transaction),
      throwsA(isA<TransactionPersistenceException>()),
    );

    expect(await service.loadAll(), hasLength(1));
    await service.close();
  });
}
