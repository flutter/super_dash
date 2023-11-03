/// Breakpoints for responsive layouts.
enum AppBreakpoints {
  /// Max width for a small layout.
  small,

  /// Max width for a medium layout.
  medium,

  /// Max width for a large layout.
  large,

  /// Max width for an extra large layout.
  extraLarge;

  const AppBreakpoints();

  /// The size of the breakpoint.
  double get size {
    return switch (this) {
      AppBreakpoints.small => 768,
      AppBreakpoints.medium => 992,
      AppBreakpoints.large => 1200,
      AppBreakpoints.extraLarge => 1400,
    };
  }
}
