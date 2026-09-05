import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/palette.dart';

/// A solid, flat, flush-left-labelled button matching `.btn-primary`
/// from the source design system (zero radius, bold Archivo label).
class AppButton extends StatelessWidget {
  final String label;
  final Palette palette;
  final Color background;
  final Color foreground;
  final VoidCallback? onPressed;
  final IconData? icon;
  final EdgeInsetsGeometry padding;

  const AppButton({
    super.key,
    required this.label,
    required this.palette,
    required this.background,
    required this.foreground,
    required this.onPressed,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: foreground),
                const SizedBox(width: 6),
              ],
              Text(label, style: headingStyle(palette, size: 13, color: foreground)),
            ],
          ),
        ),
      ),
    );
  }
}

/// The bordered, transparent-background sibling of [AppButton]
/// (`.btn-secondary` — used for "İptal" and other low-emphasis actions).
class AppOutlineButton extends StatelessWidget {
  final String label;
  final Palette palette;
  final VoidCallback? onPressed;

  const AppOutlineButton({super.key, required this.label, required this.palette, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(border: Border.all(color: palette.border)),
          child: Text(label, style: headingStyle(palette, size: 12, color: palette.textMuted)),
        ),
      ),
    );
  }
}
