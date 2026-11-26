import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/sale_transaction.dart';

class TransactionHistoryService {
  /// Membuat service riwayat dengan factory dan lokasi database opsional.
  TransactionHistoryService({this.databaseFactory, this.databasePath});

  final sqflite.DatabaseFactory? databaseFactory;
  final String? databasePath;
  Future<sqflite.Database>? _database;

  /// Menyimpan header transaksi dan seluruh item pembeliannya dalam satu transaksi database.
  Future<void> save(SaleTransaction transaction) async {
    try {
      final database = await _getDatabase();
      await database.transaction((txn) async {
        await txn.insert('transactions', {
          'id': transaction.id,
          'created_at': transaction.createdAt.toIso8601String(),
          'cashier_name': transaction.cashierName,
          'amount_paid': transaction.amountPaid,
          'total': transaction.total,
        });

        final batch = txn.batch();
        for (final item in transaction.items) {
          batch.insert('transaction_items', {
            'transaction_id': transaction.id,
            'product_id': item.product.id,
            'product_name': item.product.name,
            'product_price': item.product.price,
            'product_image_url': item.product.imageUrl,
            'quantity': item.quantity,
          });
        }
        await batch.commit(noResult: true);
      });
    } on sqflite.DatabaseException catch (error) {
      throw TransactionPersistenceException(
        'Transaksi tidak dapat disimpan: $error',
      );
    } on PlatformException catch (error) {
      throw TransactionPersistenceException(
        'Transaksi tidak dapat disimpan: ${error.message ?? error.code}',
      );
    }
  }

  /// Memuat seluruh riwayat transaksi beserta itemnya dari database.
  Future<List<SaleTransaction>> loadAll() async {
    try {
      final database = await _getDatabase();
      final rows = await database.query(
        'transactions',
        orderBy: 'created_at DESC, id DESC',
      );
      final transactions = <SaleTransaction>[];

      for (final row in rows) {
        final id = row['id'] as String;
        final itemRows = await database.query(
          'transaction_items',
          where: 'transaction_id = ?',
          whereArgs: [id],
          orderBy: 'id ASC',
        );
        final items = itemRows.map((item) {
          return CartItem(
            product: Product(
              id: item['product_id'] as int,
              name: item['product_name'] as String,
              price: item['product_price'] as int,
              imageUrl: item['product_image_url'] as String?,
            ),
            quantity: item['quantity'] as int,
          );
        }).toList();

        transactions.add(
          SaleTransaction(
            id: id,
            createdAt: DateTime.parse(row['created_at'] as String),
            cashierName: row['cashier_name'] as String,
            items: items,
            amountPaid: row['amount_paid'] as int,
          ),
        );
      }

      return List.unmodifiable(transactions);
    } on sqflite.DatabaseException catch (error) {
      throw TransactionPersistenceException(
        'Riwayat transaksi tidak dapat dimuat: $error',
      );
    } on PlatformException catch (error) {
      throw TransactionPersistenceException(
        'Riwayat transaksi tidak dapat dimuat: '
        '${error.message ?? error.code}',
      );
    }
  }

  /// Menutup koneksi database yang masih aktif dan menghapus referensi cache-nya.
  Future<void> close() async {
    final databaseFuture = _database;
    if (databaseFuture == null) return;

    await (await databaseFuture).close();
    _database = null;
  }

  /// Mengambil koneksi database yang sudah ada atau membukanya bila belum tersedia.
  Future<sqflite.Database> _getDatabase() {
    return _database ??= _openDatabase();
  }

  /// Membuka database dan membuat tabel transaksi beserta item transaksinya.
  Future<sqflite.Database> _openDatabase() async {
    final resolvedDatabasePath =
        databasePath ??
        path.join(
          await sqflite.getDatabasesPath(),
          'kasir_digital_transactions.db',
        );

    final factory = databaseFactory ?? sqflite.databaseFactory;
    return factory.openDatabase(
      resolvedDatabasePath,
      options: sqflite.OpenDatabaseOptions(
        version: 1,
        onConfigure: (database) async {
          await database.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (database, version) async {
          await database.execute('''
            CREATE TABLE transactions (
              id TEXT PRIMARY KEY,
              created_at TEXT NOT NULL,
              cashier_name TEXT NOT NULL,
              amount_paid INTEGER NOT NULL,
              total INTEGER NOT NULL
            )
          ''');
          await database.execute('''
            CREATE TABLE transaction_items (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              transaction_id TEXT NOT NULL,
              product_id INTEGER NOT NULL,
              product_name TEXT NOT NULL,
              product_price INTEGER NOT NULL,
              product_image_url TEXT,
              quantity INTEGER NOT NULL,
              FOREIGN KEY (transaction_id) REFERENCES transactions(id)
                ON DELETE CASCADE
            )
          ''');
        },
      ),
    );
  }
}

class TransactionPersistenceException implements Exception {
  /// Membuat exception yang berisi pesan kegagalan penyimpanan atau pembacaan.
  const TransactionPersistenceException(this.message);

  final String message;

  @override
  /// Mengembalikan pesan exception sebagai teks.
  String toString() => message;
}
