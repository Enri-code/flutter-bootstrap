import 'package:bootstrap/core.dart';
import 'package:flutter/material.dart';

class BootstrapSearchField extends StatelessWidget {
  const BootstrapSearchField({
    required this.onChanged,
    this.hintText = 'Search...',
    super.key,
  });

  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return BootstrapTextField(
      onChanged: onChanged,
      hintText: hintText,
      icon: Icons.search_rounded,
    );
  }
}
