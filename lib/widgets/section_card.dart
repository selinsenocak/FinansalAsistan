import 'package:flutter/material.dart';

import '../theme/palette.dart';

/// The flat, square-cornered, bordered surface used for every card
/// throughout the app (dashboard tiles, list panels, forms, …), matching
/// `.card` + `.elev-sm` in the source design system.
class SectionCard extends StatelessWidget {
  final Palette palette;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const SectionCard({
    super.key,
    required this.palette,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border.all(color: palette.border),
        boxShadow: [BoxShadow(color: palette.shadow, blurRadius: 2, offset: const Offset(0, 1))],
      ),
      child: child,
    );
  }
}
