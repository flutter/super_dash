import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_dialog}
/// A dialog with a close button in the top right corner.
/// {@endtemplate}
class AppDialog extends StatelessWidget {
  /// {@macro app_dialog}
  const AppDialog({
    required this.child,
    this.showCloseButton = true,
    this.backgroundColor = const Color(0xE51B1B36),
    this.gradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(81, 177, 177, 177),
        Color.fromARGB(51, 54, 53, 103),
        Color.fromARGB(230, 27, 27, 54),
      ],
      stops: [0.05, 0.5, 1],
    ),
    this.border,
    super.key,
  });

  /// The content of the dialog.
  final Widget child;

  /// Whether to show a close button in the top right corner.
  final bool showCloseButton;

  /// The background color of the dialog. Shown behind the [gradient].
  final Color? backgroundColor;

  /// The gradient of the dialog. Shown on top of the [backgroundColor].
  final LinearGradient? gradient;

  /// The border of the dialog.
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(24));

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: borderRadius),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 328, maxHeight: 624),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: border,
          color: backgroundColor,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: gradient,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showCloseButton) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GameIconButton(
                        icon: Icons.close,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
