import 'package:flutter/material.dart';

import '../models/sale_transaction.dart';
import '../services/transaction_history_service.dart';
import '../utils/format_date_time.dart';
import '../utils/format_rupiah.dart';
import 'receipt_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key, required this.historyService});

  final TransactionHistoryService historyService;

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late Future<List<SaleTransaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = widget.historyService.loadAll();
  }

  void _retryLoading() {
    setState(() {
      _transactionsFuture = widget.historyService.loadAll();
    });
  }

  void _openReceipt(SaleTransaction transaction) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReceiptScreen(transaction: transaction),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat transaksi')),
      body: FutureBuilder<List<SaleTransaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 40),
                    const SizedBox(height: 12),
                    const Text(
                      'Riwayat transaksi gagal dimuat.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _retryLoading,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final transactions = snapshot.data ?? const <SaleTransaction>[];
          if (transactions.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 48),
                  SizedBox(height: 12),
                  Text('Belum ada transaksi tersimpan.'),
                ],
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: transactions.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card(
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: const CircleAvatar(
                        child: Icon(Icons.receipt_long_outlined),
                      ),
                      title: Text(
                        formatRupiah(transaction.total),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        '${transaction.id}\n'
                        '${transaction.cashierName} · '
                        '${formatDateTime(transaction.createdAt)}',
                      ),
                      isThreeLine: true,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _openReceipt(transaction),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
