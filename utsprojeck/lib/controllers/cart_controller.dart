import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartController extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  /// Mengembalikan daftar item sebagai koleksi yang tidak dapat dimodifikasi.
  List<CartItem> get items => List.unmodifiable(_items.values);

  /// Menghitung jumlah seluruh unit produk yang ada di keranjang.
  int get itemCount =>
      _items.values.fold(0, (total, item) => total + item.quantity);

  /// Menghitung total harga seluruh item di keranjang.
  int get total => _items.values.fold(0, (sum, item) => sum + item.subtotal);

  /// Menambah satu unit produk ke keranjang dan memberitahu widget pemantau.
  void add(Product product) {
    final existing = _items[product.id];
    _items[product.id] = CartItem(
      product: product,
      quantity: (existing?.quantity ?? 0) + 1,
    );
    notifyListeners();
  }

  /// Mengurangi satu unit produk atau menghapusnya jika jumlah tinggal satu.
  void decrement(Product product) {
    final existing = _items[product.id];
    if (existing == null) return;

    if (existing.quantity == 1) {
      _items.remove(product.id);
    } else {
      _items[product.id] = CartItem(
        product: product,
        quantity: existing.quantity - 1,
      );
    }
    notifyListeners();
  }

  /// Menghapus produk tertentu dari keranjang.
  void remove(Product product) {
    if (_items.remove(product.id) != null) {
      notifyListeners();
    }
  }

  /// Mengosongkan seluruh isi keranjang dan memperbarui widget pemantau.
  void clear() {
    if (_items.isEmpty) return;

    _items.clear();
    notifyListeners();
  }
}
