class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
  }) {
    if (id < 0) {
      throw ArgumentError.value(id, 'id', 'must not be negative');
    }
    if (name.trim().isEmpty) {
      throw ArgumentError.value(name, 'name', 'must not be empty');
    }
    if (price < 0) {
      throw ArgumentError.value(price, 'price', 'must not be negative');
    }
  }

  final int id;
  final String name;
  final int price;
  final String? imageUrl;

  factory Product.fromJson(Map<String, dynamic> json) {
    final id = _parseInt(json['id'], 'id');
    final name = json['name'];
    final price = _parseInt(json['price'], 'price');

    if (name is! String || name.trim().isEmpty) {
      throw const FormatException('Product name must not be empty.');
    }
    if (price < 0) {
      throw const FormatException('Product price must not be negative.');
    }

    final imageUrl = json['imageUrl'];
    if (imageUrl != null && imageUrl is! String) {
      throw const FormatException('Product imageUrl must be a string.');
    }

    return Product(
      id: id,
      name: name,
      price: price,
      imageUrl: imageUrl as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    if (imageUrl != null) 'imageUrl': imageUrl,
  };
}

int _parseInt(Object? value, String fieldName) {
  if (value is int) return value;
  if (value is num && value == value.roundToDouble()) return value.toInt();
  if (value is String) {
    final parsed = int.tryParse(value);
    if (parsed != null) return parsed;
  }
  throw FormatException('Product $fieldName must be an integer.');
}
