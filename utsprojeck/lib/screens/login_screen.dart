import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/cashier_auth_controller.dart';
import '../services/cashier_auth_service.dart';

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
    final theme = Theme.of(context);
    final isFirstRun = _isFirstRun;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F1E3), Color(0xFFEFE6D2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      const SizedBox(height: 48),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3EFE7),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            isFirstRun ? 'Edisi 01 · Prototipe' : 'Kasir UMKM',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: const Color(0xFF6B6A65),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Catat penjualan,\ntanpa repot.',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Masuk untuk memulai\ntransaksi hari ini.',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        key: const Key('cashier-name'),
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Nama kasir',
                        ),
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
                          decoration: const InputDecoration(
                            labelText: 'Ulangi PIN',
                          ),
                          validator: _validatePin,
                          onFieldSubmitted: (_) => _submit(),
                        ),
                      ],
                      if (_errorMessage case final message?) ...[
                        const SizedBox(height: 16),
                        Text(
                          message,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
