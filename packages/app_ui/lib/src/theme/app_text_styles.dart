import 'package:flutter/material.dart';

/// Text styles used in the app.
class AppTextStyles {
  /// Creates a [AppTextStyles].
  const AppTextStyles();

  /// Package name
  static const package = 'app_ui';

  /// Creates a [TextTheme] from the text styles.
  static TextTheme textTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );

  static const TextStyle _commonStyle = TextStyle(
    fontFamily: 'Google Sans',
    color: Colors.white,
    package: package,
    decorationColor: Colors.white,
  );

  /// Display large text style.
  static TextStyle get displayLarge => _commonStyle;

  /// Display medium text style.
  static TextStyle get displayMedium => _commonStyle;

  /// Display small text style.
  static TextStyle get displaySmall => _commonStyle;

  /// Headline large text style.
  static TextStyle get headlineLarge => _commonStyle;

  /// Headline medium text style.
  static TextStyle get headlineMedium => _commonStyle;

  /// Headline small text style.
  static TextStyle get headlineSmall => _commonStyle;

  /// Title large text style.
  static TextStyle get titleLarge => _commonStyle;

  /// Title medium text style.
  static TextStyle get titleMedium => _commonStyle;

  /// Title small text style.
  static TextStyle get titleSmall => _commonStyle;

  /// Body large text style.
  static TextStyle get bodyLarge => _commonStyle.copyWith(
        fontSize: 16,
        height: 1.5,
      );

  /// Body medium text style.
  static TextStyle get bodyMedium => _commonStyle;

  /// Body small text style.
  static TextStyle get bodySmall => _commonStyle;

  /// Label large text style.
  static TextStyle get labelLarge => _commonStyle;

  /// Label medium text style.
  static TextStyle get labelMedium => _commonStyle;

  /// Label small text style.
  static TextStyle get labelSmall => _commonStyle;
}
