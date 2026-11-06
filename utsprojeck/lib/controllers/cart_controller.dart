import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartController extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  List<CartItem> get items => List.unmodifiable(_items.values);

  int get itemCount =>
      _items.values.fold(0, (total, item) => total + item.quantity);

  int get total => _items.values.fold(0, (sum, item) => sum + item.subtotal);

  void add(Product product) {
    final existing = _items[product.id];
    _items[product.id] = CartItem(
      product: product,
      quantity: (existing?.quantity ?? 0) + 1,
    );
    notifyListeners();
  }

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

  void remove(Product product) {
    if (_items.remove(product.id) != null) {
      notifyListeners();
    }
  }

  void clear() {
    if (_items.isEmpty) return;

    _items.clear();
    notifyListeners();
  }
}
