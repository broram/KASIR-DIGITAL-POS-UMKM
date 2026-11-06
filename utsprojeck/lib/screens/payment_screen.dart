import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/cart_controller.dart';
import '../models/sale_transaction.dart';
import '../utils/format_rupiah.dart';
import 'receipt_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.cartController});

  final CartController cartController;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _paymentController = TextEditingController();
  int? _amountPaid;
  bool _isConfirming = false;

  @override
  void dispose() {
    _paymentController.dispose();
    super.dispose();
  }

  int get _total => widget.cartController.total;

  int? get _change {
    final amountPaid = _amountPaid;
    if (amountPaid == null || amountPaid < _total) return null;
    return amountPaid - _total;
  }

  String? _validatePayment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Masukkan nominal pembayaran.';
    }

    final amount = int.tryParse(value);
    if (amount == null) {
      return 'Nominal pembayaran tidak valid.';
    }
    if (amount < _total) {
      return 'Pembayaran kurang ${formatRupiah(_total - amount)}.';
    }
    return null;
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final amountPaid = int.parse(_paymentController.text);
    final transaction = SaleTransaction(
      id: 'TRX-${DateTime.now().microsecondsSinceEpoch}',
      createdAt: DateTime.now(),
      items: widget.cartController.items,
      amountPaid: amountPaid,
    );

    setState(() {
      _isConfirming = true;
    });
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi transaksi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total belanja: ${formatRupiah(transaction.total)}'),
            const SizedBox(height: 8),
            Text('Uang diterima: ${formatRupiah(transaction.amountPaid)}'),
            const SizedBox(height: 8),
            Text('Kembalian: ${formatRupiah(transaction.change)}'),
            const SizedBox(height: 12),
            const Text('Selesaikan transaksi ini?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Periksa lagi'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
    if (!mounted) return;

    setState(() {
      _isConfirming = false;
    });
    if (confirmed != true) return;

    widget.cartController.clear();
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ReceiptScreen(transaction: transaction),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final change = _change;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selesaikan transaksi',
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Masukkan uang yang diterima dari pelanggan.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Card(
                margin: EdgeInsets.zero,
                color: colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total tagihan',
                              style: TextStyle(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatRupiah(_total),
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Nominal pembayaran',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _paymentController,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  prefixText: 'Rp ',
                  hintText: 'Contoh: 50000',
                  border: OutlineInputBorder(),
                  helperText: 'Masukkan angka tanpa titik atau simbol.',
                ),
                validator: _validatePayment,
                onChanged: (value) {
                  setState(() {
                    _amountPaid = int.tryParse(value);
                  });
                },
              ),
              const SizedBox(height: 20),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.currency_exchange_outlined),
                      const SizedBox(width: 12),
                      const Expanded(child: Text('Kembalian')),
                      Text(
                        change == null ? '—' : formatRupiah(change),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: _isConfirming ? null : _submitPayment,
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Bayar dan selesaikan'),
        ),
      ),
    );
  }
}
