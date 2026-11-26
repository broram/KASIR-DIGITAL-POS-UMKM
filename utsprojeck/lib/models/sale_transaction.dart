import 'cart_item.dart';

class SaleTransaction {
  /// Membuat transaksi dan memvalidasi kasir, daftar item, serta pembayaran.
  SaleTransaction({
    required this.id,
    required this.createdAt,
    required this.cashierName,
    required List<CartItem> items,
    required this.amountPaid,
  }) : items = List.unmodifiable(items) {
    if (cashierName.trim().isEmpty) {
      throw ArgumentError.value(
        cashierName,
        'cashierName',
        'must not be empty',
      );
    }
    if (this.items.isEmpty) {
      throw ArgumentError.value(items, 'items', 'must not be empty');
    }
    if (amountPaid < total) {
      throw ArgumentError.value(
        amountPaid,
        'amountPaid',
        'must cover the transaction total',
      );
    }
  }

  final String id;
  final DateTime createdAt;
  final String cashierName;
  final List<CartItem> items;
  final int amountPaid;

  /// Menghitung total belanja pada transaksi.
  int get total => items.fold(0, (sum, item) => sum + item.subtotal);

  /// Menghitung selisih pembayaran dan total belanja sebagai kembalian.
  int get change => amountPaid - total;

  /// Mengubah transaksi menjadi data JSON untuk penyimpanan atau pencatatan.
  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'cashierName': cashierName,
    'items': items.map((item) => item.toJson()).toList(),
    'total': total,
    'amountPaid': amountPaid,
    'change': change,
  };
}
