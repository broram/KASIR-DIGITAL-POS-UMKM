import 'product.dart';

class CartItem {
  /// Membuat item keranjang dan memastikan jumlah produk minimal satu.
  CartItem({required this.product, this.quantity = 1}) {
    if (quantity < 1) {
      throw ArgumentError.value(quantity, 'quantity', 'must be at least 1');
    }
  }

  final Product product;
  final int quantity;

  /// Menghitung subtotal dari harga produk dikali jumlah item.
  int get subtotal => product.price * quantity;

  /// Mengubah item keranjang menjadi data JSON.
  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
    'subtotal': subtotal,
  };
}
