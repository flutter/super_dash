import 'package:flutter/material.dart';

/// {@template page_with_background}
/// A page with a background for responsive design.
/// {@endtemplate}
class PageWithBackground extends StatelessWidget {
  /// {@macro page_with_background}
  const PageWithBackground({
    required this.background,
    required this.child,
    super.key,
  });

  /// The background widget.
  final Widget background;

  /// The child widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).aspectRatio > .56) {
      return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            background,
            AspectRatio(
              aspectRatio: .56,
              child: child,
            ),
          ],
        ),
      );
    }
    return Scaffold(body: child);
  }
}
