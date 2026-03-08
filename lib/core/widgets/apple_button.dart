import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Un bottone generico in stile Apple/iOS, riutilizzabile in tutta l'app.
/// Usa uno stile minimale, angoli molto arrotondati e padding generoso.
class AppleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppleButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (backgroundColor ?? Theme.of(context).primaryColor)
                  .withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: foregroundColor ?? Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: foregroundColor ?? Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: -0.5, // Apple-style typography
              ),
            ),
          ],
        ),
      ),
    );
  }
}
