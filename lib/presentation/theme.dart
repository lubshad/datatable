import 'package:flutter/material.dart';

const defaultPadding = 16.0;
const defaultPaddingLarge = 32.0;
const defaultSpacer = SizedBox(height: defaultPadding);
const defaultSpacerHorizontal = SizedBox(width: defaultPadding);
const defaultSpacerHorizontalLarge = SizedBox(width: defaultPaddingLarge);

class AppTheme {
  static ThemeData theme = ThemeData(
      platform: TargetPlatform.windows,
      primarySwatch: Colors.blue,
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        actionsIconTheme: IconThemeData(color: Colors.black),
      ));
}
