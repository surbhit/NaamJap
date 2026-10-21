import 'package:flutter/material.dart';

const chantGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFFEE3B4),
    Color(0xFFFEA458),
    Color(0xFFD56B21),
  ],
  stops: [0.0, 0.48, 1.0],
);

const chantBrown = Color(0xFF8C440F);
const chantBrownSoft = Color(0xFF9A4E16);
const chantCream = Color(0xFFFFF6EC);

class ChantScaffold extends StatelessWidget {
  const ChantScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD56B21),
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: chantGradient),
        child: child,
      ),
    );
  }
}

class ChantIconButton extends StatelessWidget {
  const ChantIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: chantBrown, size: 22),
          ),
        ),
      ),
    );
  }
}

class ChantCard extends StatelessWidget {
  const ChantCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0x66FFFFFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(18),
        child: child,
      ),
    );
  }
}
