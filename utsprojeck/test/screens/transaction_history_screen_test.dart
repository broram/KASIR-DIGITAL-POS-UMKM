import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utsprojeck/models/cart_item.dart';
import 'package:utsprojeck/models/product.dart';
import 'package:utsprojeck/models/sale_transaction.dart';
import 'package:utsprojeck/screens/transaction_history_screen.dart';
import 'package:utsprojeck/services/transaction_history_service.dart';

void main() {
  testWidgets('history lists saved transactions and opens their receipt', (
    tester,
  ) async {
    final service = _FakeTransactionHistoryService([
      SaleTransaction(
        id: 'TRX-001',
        createdAt: DateTime(2026, 11, 15, 10, 30),
        cashierName: 'Ramdan',
        items: [CartItem(product: Product(id: 1, name: 'Kopi', price: 12000))],
        amountPaid: 20000,
      ),
    ]);

    await tester.pumpWidget(
      MaterialApp(home: TransactionHistoryScreen(historyService: service)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Riwayat transaksi'), findsOneWidget);
    expect(find.text('Rp 12.000'), findsOneWidget);
    expect(find.textContaining('TRX-001'), findsOneWidget);

    await tester.tap(find.text('Rp 12.000'));
    await tester.pumpAndSettle();

    expect(find.text('Struk transaksi'), findsOneWidget);
    expect(find.text('Ramdan'), findsOneWidget);
    expect(find.text('Kopi'), findsOneWidget);
  });
}

class _FakeTransactionHistoryService extends TransactionHistoryService {
  _FakeTransactionHistoryService(this.transactions);

  final List<SaleTransaction> transactions;

  @override
  Future<List<SaleTransaction>> loadAll() async =>
      List.unmodifiable(transactions);
}
