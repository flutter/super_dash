import 'package:dash_run/game/game.dart';
import 'package:dash_run/l10n/l10n.dart';
import 'package:dash_run/map_tester/map_tester.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    this.isTesting = false,
  });

  final bool isTesting;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: isTesting ? const MapTesterView() : const GameView(),
    );
  }
}
