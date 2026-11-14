import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'controllers/cashier_auth_controller.dart';
import 'controllers/cart_controller.dart';
import 'screens/catalog_screen.dart';
import 'screens/login_screen.dart';
import 'services/product_catalog_service.dart';
import 'services/cashier_auth_service.dart';
import 'services/transaction_history_service.dart';
import 'theme/app_theme.dart';

void main() {
  if (!kIsWeb &&
      {
        TargetPlatform.linux,
        TargetPlatform.macOS,
        TargetPlatform.windows,
      }.contains(defaultTargetPlatform)) {
    sqfliteFfiInit();
    sqflite.databaseFactory = databaseFactoryFfi;
  }
  runApp(const KasirApp());
}

class KasirApp extends StatefulWidget {
  const KasirApp({super.key});

  @override
  State<KasirApp> createState() => _KasirAppState();
}

class _KasirAppState extends State<KasirApp> {
  late final CartController _cartController;
  late final CashierAuthController _authController;
  late final TransactionHistoryService _historyService;

  @override
  void initState() {
    super.initState();
    _cartController = CartController();
    _authController = CashierAuthController(
      authService: LocalCashierAuthService(),
    );
    _historyService = TransactionHistoryService();
  }

  @override
  void dispose() {
    _cartController.dispose();
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasir UMKM',
      theme: AppTheme.light,
      home: _AppEntry(
        cartController: _cartController,
        authController: _authController,
        historyService: _historyService,
      ),
    );
  }
}

class _AppEntry extends StatefulWidget {
  const _AppEntry({
    required this.cartController,
    required this.authController,
    required this.historyService,
  });

  final CartController cartController;
  final CashierAuthController authController;
  final TransactionHistoryService historyService;

  @override
  State<_AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<_AppEntry> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = widget.authController.initialize();
  }

  void _retryInitialization() {
    setState(() {
      _initialization = widget.authController.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Data login kasir gagal dimuat.'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _retryInitialization,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return AnimatedBuilder(
          animation: widget.authController,
          builder: (context, _) {
            if (!widget.authController.isLoggedIn) {
              return LoginScreen(authController: widget.authController);
            }

            return CatalogScreen(
              cartController: widget.cartController,
              loadProducts: ProductCatalogService.loadProducts,
              historyService: widget.historyService,
              cashierName: widget.authController.cashierName!,
              onLogout: () {
                widget.cartController.clear();
                widget.authController.logout();
              },
            );
          },
        );
      },
    );
  }
}
