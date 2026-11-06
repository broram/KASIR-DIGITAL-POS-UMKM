import 'product.dart';

class CartItem {
  CartItem({required this.product, this.quantity = 1}) {
    if (quantity < 1) {
      throw ArgumentError.value(quantity, 'quantity', 'must be at least 1');
    }
  }

  final Product product;
  final int quantity;

  int get subtotal => product.price * quantity;

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
    'subtotal': subtotal,
  };
}
