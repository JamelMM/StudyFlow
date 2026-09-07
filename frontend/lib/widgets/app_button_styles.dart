import 'package:flutter/material.dart';

ButtonStyle appPrimaryButtonStyle(BuildContext context) {
  final appBarTheme = Theme.of(context).appBarTheme;
  final colorScheme = Theme.of(context).colorScheme;

  return FilledButton.styleFrom(
    backgroundColor: appBarTheme.backgroundColor ?? colorScheme.primary,
    foregroundColor: appBarTheme.foregroundColor ?? colorScheme.onPrimary,
  );
}
