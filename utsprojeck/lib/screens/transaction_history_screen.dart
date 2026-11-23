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
      body: FutureBuilder<List<SaleTransaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF7F1E3), Color(0xFFEFE6D2)],
              ),
            ),
            child: Column(
              children: [
                _HistoryHeader(onBack: () => Navigator.of(context).pop()),
                Expanded(
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1F3D2F),
                          ),
                        )
                      : snapshot.hasError
                      ? _HistoryError(onRetry: _retryLoading)
                      : _HistoryList(
                          transactions:
                              snapshot.data ?? const <SaleTransaction>[],
                          onOpen: _openReceipt,
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A4D3C), Color(0xFF1F3D2F)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x471F3D2F),
            offset: Offset(0, 14),
            blurRadius: 28,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'KASIR DIGITAL',
                style: TextStyle(
                  color: Color(0xFFD1B574),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(75, 44),
                  foregroundColor: const Color(0xFFF4EDDD),
                  side: const BorderSide(color: Color(0x4DF4EDDD)),
                  backgroundColor: const Color(0x24F4EDDD),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                child: const Text('Kembali'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Riwayat transaksi',
            style: TextStyle(
              color: Color(0xFFF4EDDD),
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.6,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Transaksi terbaru di atas',
            style: TextStyle(color: Color(0xFFE9DFCB), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _HistoryError extends StatelessWidget {
  const _HistoryError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
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
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.transactions, required this.onOpen});

  final List<SaleTransaction> transactions;
  final ValueChanged<SaleTransaction> onOpen;

  @override
  Widget build(BuildContext context) {
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
            final cardColors = [
              const Color(0xFFFBF7EC),
              const Color(0xFFEFE6D2),
              const Color(0xFFC9D3C0),
            ];
            return Material(
              color: cardColors[index % cardColors.length],
              borderRadius: BorderRadius.circular(24),
              elevation: 0,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => onOpen(transaction),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x242F5040),
                        offset: Offset(0, 10),
                        blurRadius: 22,
                      ),
                      BoxShadow(
                        color: Color(0x8CFFFFFF),
                        offset: Offset(0, 1),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transaksi #${index + 1}',
                              style: const TextStyle(
                                color: Color(0xFF1F3D2F),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${formatDateTime(transaction.createdAt)} · '
                              '${transaction.cashierName} · '
                              '${transaction.id}',
                              style: const TextStyle(
                                color: Color(0xFF3F5045),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        formatRupiah(transaction.total),
                        style: const TextStyle(
                          color: Color(0xFF1F3D2F),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '›',
                        style: TextStyle(
                          color: Color(0xFF1F3D2F),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
