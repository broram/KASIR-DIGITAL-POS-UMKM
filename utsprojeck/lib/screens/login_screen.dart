import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/cashier_auth_controller.dart';
import '../services/cashier_auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/botanical_decor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.authController});

  final CashierAuthController authController;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _defaultCashierName = 'Ramdan';

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  bool get _isFirstRun => widget.authController.registeredCashier == null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.authController.registeredCashier ?? _defaultCashierName,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isFirstRun && _pinController.text != _confirmPinController.text) {
      setState(() {
        _errorMessage = 'Konfirmasi PIN tidak sama.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      if (_isFirstRun) {
        await widget.authController.register(
          name: _nameController.text,
          pin: _pinController.text,
        );
      } else {
        final authenticated = await widget.authController.login(
          name: _nameController.text,
          pin: _pinController.text,
        );
        if (!authenticated && mounted) {
          _pinController.clear();
          setState(() {
            _errorMessage = 'Nama kasir atau PIN tidak sesuai.';
          });
        }
      }
    } on CashierAuthException catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = error.message;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama kasir wajib diisi.';
    }
    return null;
  }

  String? _validatePin(String? value) {
    if (value == null || !RegExp(r'^\d{4,6}$').hasMatch(value)) {
      return 'PIN harus terdiri dari 4–6 digit.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppTheme.canvasGradient),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (isDesktopWidth(context)) {
              return SafeArea(
                child: DesktopSplitLayout(
                  heroWidth: (constraints.maxWidth * 0.52)
                      .clamp(480.0, 600.0)
                      .toDouble(),
                  hero: const _LoginHero(),
                  form: _buildLoginForm(context),
                ),
              );
            }

            return Stack(
              children: [
                const Positioned(
                  right: -62,
                  bottom: 80,
                  child: BotanicalLeaf(
                    width: 180,
                    height: 250,
                    angleDegrees: 18,
                    opacity: 0.12,
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: _buildLoginForm(context),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final theme = Theme.of(context);
    final isFirstRun = _isFirstRun;

    return SoftCard(
      padding: const EdgeInsets.all(28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'KASIR DIGITAL',
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  'POS UMKM',
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.beige,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isFirstRun ? 'Edisi 01 · Prototipe' : 'Kasir UMKM',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Catat penjualan,\ntanpa repot.',
              style: theme.textTheme.headlineMedium?.copyWith(height: 1.1),
            ),
            const SizedBox(height: 12),
            Text(
              'Masuk untuk memulai transaksi hari ini.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 28),
            TextFormField(
              key: const Key('cashier-name'),
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Nama kasir'),
              validator: _validateName,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('cashier-pin'),
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              textInputAction: isFirstRun
                  ? TextInputAction.next
                  : TextInputAction.done,
              decoration: const InputDecoration(labelText: 'PIN'),
              validator: _validatePin,
              onFieldSubmitted: isFirstRun ? null : (_) => _submit(),
            ),
            if (isFirstRun) ...[
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('cashier-pin-confirm'),
                controller: _confirmPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Ulangi PIN'),
                validator: _validatePin,
                onFieldSubmitted: (_) => _submit(),
              ),
            ],
            if (_errorMessage case final message?) ...[
              const SizedBox(height: 16),
              Text(message, style: TextStyle(color: theme.colorScheme.error)),
            ],
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: Text(
                _isSubmitting
                    ? 'Memproses...'
                    : isFirstRun
                    ? 'Buat profil'
                    : 'Masuk',
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            Text(
              'Prototipe UTS · Data lokal',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginHero extends StatelessWidget {
  const _LoginHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: BotanicalPanel(
        padding: const EdgeInsets.all(48),
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(36)),
        leaves: const [
          Positioned(
            right: -50,
            top: 24,
            child: BotanicalLeaf(
              width: 180,
              height: 260,
              angleDegrees: 24,
              opacity: 0.24,
            ),
          ),
          Positioned(
            right: 80,
            bottom: -96,
            child: BotanicalLeaf(
              width: 160,
              height: 230,
              angleDegrees: -28,
              opacity: 0.16,
              colors: [AppTheme.sage, AppTheme.teal],
            ),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'KASIR DIGITAL  /  POS UMKM',
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: AppTheme.gold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.storefront_outlined,
                  size: 44,
                  color: AppTheme.gold,
                ),
                const SizedBox(height: 24),
                Text(
                  'Kelola usaha,\ndengan lebih tenang.',
                  style: Theme.of(context).textTheme.displayLarge
                      ?.copyWith(color: AppTheme.onDark, fontSize: 48),
                ),
                const SizedBox(height: 16),
                Text(
                  'Catat transaksi harian dan pantau penjualan '
                  'dalam satu tempat.',
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: AppTheme.onDarkMuted),
                ),
              ],
            ),
            Text(
              'Sederhana untuk usaha lokal.',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppTheme.onDarkMuted),
            ),
          ],
        ),
      ),
    );
  }
}
