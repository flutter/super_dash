import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:super_dash/app/view/app.dart';
import 'package:super_dash/l10n/l10n.dart';

class GameSelectLanguageOverlay extends StatelessWidget {
  const GameSelectLanguageOverlay({super.key});

  static PageRoute<void> route() {
    return HeroDialogRoute(
      builder: (_) => BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: const GameSelectLanguageOverlay(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const GameSelectLanguageOverlayView();
  }
}

class GameSelectLanguageOverlayView extends StatefulWidget {
  const GameSelectLanguageOverlayView({super.key});

  @override
  State<GameSelectLanguageOverlayView> createState() =>
      _GameSelectLanguageOverlayViewState();
}

class _GameSelectLanguageOverlayViewState
    extends State<GameSelectLanguageOverlayView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return AppDialog(
      showCloseButton: false,
      border: Border.all(color: Colors.white24),
      backgroundColor: Colors.white24,
      child: Column(
        children: <Widget>[
          Text(
            l10n.selectLanguage,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AppLocalizations.supportedLocales
                .map(
                  (e) => InkWell(
                    onTap: () {
                      App.of(context)?.setLocale(
                        Locale.fromSubtags(languageCode: e.languageCode),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            e.languageCode.toUpperCase(),
                            style: textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (e.languageCode == context.l10n.localeName)
                            const Icon(
                              Icons.check,
                              size: 15,
                              color: Colors.white,
                            ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
