import 'package:flutter/material.dart';
import 'package:bootstrap/core.dart';

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
