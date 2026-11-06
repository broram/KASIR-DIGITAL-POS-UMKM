import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductCatalogService {
  static Future<List<Product>> loadProducts() async {
    final jsonString = await rootBundle.loadString('assets/data/products.json');
    final decoded = jsonDecode(jsonString);
    if (decoded is! List) {
      throw const FormatException('Product catalog must be a JSON list.');
    }

    return decoded.map((product) {
      if (product is! Map<String, dynamic>) {
        throw const FormatException('Each catalog item must be a JSON object.');
      }
      return Product.fromJson(product);
    }).toList();
  }
}
