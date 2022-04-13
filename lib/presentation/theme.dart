import 'package:flutter/material.dart';

const defaultPadding = 16.0;
const defaultSpacer = SizedBox(height: defaultPadding);

class AppTheme {
  static ThemeData theme = ThemeData(
      platform: TargetPlatform.windows,
      primarySwatch: Colors.blue,
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        actionsIconTheme: IconThemeData(color: Colors.black),
      ));
}
