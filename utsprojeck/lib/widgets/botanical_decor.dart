import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

const double kDesktopBreakpoint = 900;

/// Menentukan apakah lebar layar cukup untuk menampilkan tata letak desktop.
bool isDesktopWidth(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= kDesktopBreakpoint;

class BotanicalLeaf extends StatelessWidget {
  /// Membuat dekorasi daun yang dapat diputar, diwarnai, dan dibuat transparan.
  const BotanicalLeaf({
    super.key,
    required this.width,
    required this.height,
    this.angleDegrees = 0,
    this.colors = const [Color(0xFFA9BFA0), Color(0xFF4F7A62)],
    this.opacity = 1,
  });

  final double width;
  final double height;
  final double angleDegrees;
  final List<Color> colors;
  final double opacity;

  @override
  /// Membangun visual daun botani tanpa menyerap interaksi pengguna.
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: IgnorePointer(
        child: Opacity(
          opacity: opacity,
          child: Transform.rotate(
            angle: angleDegrees * math.pi / 180,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colors,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.elliptical(width, height),
                  bottomLeft: Radius.elliptical(width, height),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x38000000),
                    blurRadius: 24,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BotanicalPanel extends StatelessWidget {
  /// Membuat panel hijau dengan bayangan, sudut melengkung, dan dekorasi daun.
  const BotanicalPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(28),
    this.borderRadius = const BorderRadius.all(Radius.circular(32)),
    this.leaves = const [],
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final List<Widget> leaves;

  @override
  /// Membangun panel yang menumpuk dekorasi di belakang konten.
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppTheme.forestGradient,
        borderRadius: borderRadius,
        boxShadow: AppTheme.softShadow,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            ...leaves,
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}

class SoftCard extends StatelessWidget {
  /// Membuat kartu lembut yang opsional dapat diklik.
  const SoftCard({
    super.key,
    required this.child,
    this.color = AppTheme.paper,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  /// Membangun kartu dengan bayangan dan efek sentuhan.
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppTheme.radiusCard);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius,
        boxShadow: AppTheme.softShadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class DesktopCashierLayout extends StatelessWidget {
  /// Membuat tata letak desktop dengan header, katalog, dan keranjang.
  const DesktopCashierLayout({
    super.key,
    required this.header,
    required this.catalog,
    required this.cart,
    this.cartWidth = 380,
  });

  final Widget header;
  final Widget catalog;
  final Widget cart;
  final double cartWidth;

  @override
  /// Membangun susunan horizontal khusus tampilan desktop.
  Widget build(BuildContext context) {
    return Column(
      children: [
        header,
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 28, 28, 0),
                  child: catalog,
                ),
              ),
              SizedBox(
                width: cartWidth + 28,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 28, 28),
                  child: cart,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DesktopSplitLayout extends StatelessWidget {
  /// Membuat tata letak dua sisi untuk halaman login dan form.
  const DesktopSplitLayout({
    super.key,
    required this.hero,
    required this.form,
    this.heroWidth = 600,
    this.formMaxWidth = 420,
  });

  final Widget hero;
  final Widget form;
  final double heroWidth;
  final double formMaxWidth;

  @override
  /// Membangun panel ilustrasi dan form yang saling bersebelahan.
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: heroWidth, child: hero),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: formMaxWidth),
              child: Padding(padding: const EdgeInsets.all(24), child: form),
            ),
          ),
        ),
      ],
    );
  }
}
