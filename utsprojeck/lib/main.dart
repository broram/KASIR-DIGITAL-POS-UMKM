import 'package:flutter/material.dart';

import 'controllers/cart_controller.dart';
import 'screens/catalog_screen.dart';
import 'services/product_catalog_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const KasirApp());
}

class KasirApp extends StatefulWidget {
  const KasirApp({super.key});

  @override
  State<KasirApp> createState() => _KasirAppState();
}

class _KasirAppState extends State<KasirApp> {
  late final CartController _cartController;

  @override
  void initState() {
    super.initState();
    _cartController = CartController();
  }

  @override
  void dispose() {
    _cartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasir UMKM',
      theme: AppTheme.light,
      home: CatalogScreen(
        cartController: _cartController,
        loadProducts: ProductCatalogService.loadProducts,
      ),
    );
  }
}
