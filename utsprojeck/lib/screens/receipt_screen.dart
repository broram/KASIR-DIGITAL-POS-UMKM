import 'package:flutter/material.dart';

import '../models/sale_transaction.dart';
import '../utils/format_rupiah.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key, required this.transaction});

  final SaleTransaction transaction;

  String _formatDateTime(DateTime dateTime) {
    final localTime = dateTime.toLocal();
    final date =
        '${localTime.day.toString().padLeft(2, '0')}/'
        '${localTime.month.toString().padLeft(2, '0')}/${localTime.year}';
    final time =
        '${localTime.hour.toString().padLeft(2, '0')}:'
        '${localTime.minute.toString().padLeft(2, '0')}';
    return '$date $time';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Struk transaksi'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 56,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Transaksi berhasil',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kasir UMKM', style: textTheme.titleLarge),
                        const SizedBox(height: 4),
                        Text('ID transaksi: ${transaction.id}'),
                        Text(
                          'Waktu: ${_formatDateTime(transaction.createdAt)}',
                        ),
                        const Divider(height: 28),
                        ...transaction.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '${item.quantity} x '
                                        '${formatRupiah(item.product.price)}',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(formatRupiah(item.subtotal)),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 12),
                        _ReceiptAmount(
                          label: 'Total',
                          value: transaction.total,
                          emphasized: true,
                        ),
                        _ReceiptAmount(
                          label: 'Uang diterima',
                          value: transaction.amountPaid,
                        ),
                        _ReceiptAmount(
                          label: 'Kembalian',
                          value: transaction.change,
                          emphasized: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Terima kasih telah berbelanja.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Align(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Transaksi baru'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReceiptAmount extends StatelessWidget {
  const _ReceiptAmount({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final int value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = emphasized
        ? Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(formatRupiah(value), style: style),
        ],
      ),
    );
  }
}
