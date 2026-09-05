import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import '../theme/palette.dart';

/// A themed text field matching the design's flat, placeholder-only
/// `.input` style. `numeric: true` restricts input to a decimal amount.
class AppTextField extends StatelessWidget {
  final Palette palette;
  final TextEditingController controller;
  final String hint;
  final bool numeric;
  final bool obscure;

  const AppTextField({
    super.key,
    required this.palette,
    required this.controller,
    required this.hint,
    this.numeric = false,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: bodyStyle(palette, size: 14),
      keyboardType: numeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      inputFormatters: numeric ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))] : null,
      decoration: InputDecoration(hintText: hint),
    );
  }
}
