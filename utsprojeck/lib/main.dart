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

/// Menjalankan aplikasi dan menyiapkan database SQLite untuk desktop.
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
  /// Membuat widget utama aplikasi kasir.
  const KasirApp({super.key});

  @override
  /// Membuat state yang menyimpan controller global aplikasi.
  State<KasirApp> createState() => _KasirAppState();
}

class _KasirAppState extends State<KasirApp> {
  late final CartController _cartController;
  late final CashierAuthController _authController;
  late final TransactionHistoryService _historyService;

  @override
  /// Membuat controller keranjang, autentikasi, dan riwayat transaksi saat state dimulai.
  void initState() {
    super.initState();
    _cartController = CartController();
    _authController = CashierAuthController(
      authService: LocalCashierAuthService(),
    );
    _historyService = TransactionHistoryService();
  }

  @override
  /// Membebaskan resource pada controller sebelum state dihapus.
  void dispose() {
    _cartController.dispose();
    _authController.dispose();
    super.dispose();
  }

  @override
  /// Membangun konfigurasi MaterialApp beserta tema dan halaman awal.
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
  /// Menerima controller dan service yang dibagikan ke seluruh aplikasi.
  const _AppEntry({
    required this.cartController,
    required this.authController,
    required this.historyService,
  });

  final CartController cartController;
  final CashierAuthController authController;
  final TransactionHistoryService historyService;

  @override
  /// Membuat state untuk memeriksa status inisialisasi aplikasi.
  State<_AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<_AppEntry> {
  late Future<void> _initialization;

  @override
  /// Memulai proses pemuatan data login kasir saat halaman dibuka.
  void initState() {
    super.initState();
    _initialization = widget.authController.initialize();
  }

  /// Mengulang proses inisialisasi ketika pemuatan data sebelumnya gagal.
  void _retryInitialization() {
    setState(() {
      _initialization = widget.authController.initialize();
    });
  }

  @override
  /// Menampilkan loading, layar error, login, atau katalog berdasarkan status aplikasi.
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
