import 'package:app_ui/src/layout/breakpoints.dart';
import 'package:flutter/material.dart';

/// Extension on [BuildContext] to provide information about the layout.
extension BuildContextLayoutX on BuildContext {
  /// Whether the device is small.
  bool get isSmall =>
      MediaQuery.of(this).size.width < AppBreakpoints.small &&
      MediaQuery.of(this).orientation == Orientation.portrait;
}