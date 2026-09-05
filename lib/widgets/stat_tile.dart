import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/palette.dart';
import 'section_card.dart';

/// A single summary metric tile (Toplam Gelir / Toplam Gider / Bakiye /
/// Tasarruf Oranı) as seen at the top of the home screen.
class StatTile extends StatelessWidget {
  final Palette palette;
  final String label;
  final String value;
  final Color? valueColor;

  const StatTile({
    super.key,
    required this.palette,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      palette: palette,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: bodyStyle(palette, size: 12, color: palette.textMuted)),
          const SizedBox(height: 4),
          Text(
            value,
            style: headingStyle(palette, size: 20, color: valueColor ?? palette.textHeading),
          ),
        ],
      ),
    );
  }
}
