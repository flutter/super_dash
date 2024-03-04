import 'package:flutter/material.dart';
import 'package:super_dash/l10n/l10n.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

bool get isAndroid => !kIsWeb && Platform.isAndroid;
bool get isIOS => !kIsWeb && Platform.isIOS;
bool get isWindows => !kIsWeb && Platform.isWindows;
bool get isWeb => kIsWeb;

class TapToJumpOverlay extends StatelessWidget {
  const TapToJumpOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color.fromARGB(81, 177, 177, 177),
            ),
            color: const Color(0xE51B1B36),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              isAndroid || isIOS ? l10n.tapToStart : l10n.pressSpaceToStart,
              style: textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
