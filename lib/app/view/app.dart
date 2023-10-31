import 'package:dash_run/app_lifecycle/app_lifecycle.dart';
import 'package:dash_run/audio/audio.dart';
import 'package:dash_run/game_intro/game_intro.dart';
import 'package:dash_run/l10n/l10n.dart';
import 'package:dash_run/map_tester/map_tester.dart';
import 'package:dash_run/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({
    required this.settingsController,
    required this.audioController,
    this.isTesting = false,
    super.key,
  });

  final bool isTesting;
  final SettingsController settingsController;
  final AudioController audioController;

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<SettingsController>.value(
            value: settingsController,
          ),
          RepositoryProvider<AudioController>(
            create: (context) {
              final lifecycleNotifier =
                  context.read<ValueNotifier<AppLifecycleState>>();
              return audioController
                ..attachLifecycleNotifier(lifecycleNotifier);
            },
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              color: Color(0xFF13B9FF),
            ),
            colorScheme: ColorScheme.fromSwatch(
              accentColor: const Color(0xFF13B9FF),
            ),
          ),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: isTesting ? const MapTesterView() : const GameIntroPage(),
        ),
      ),
    );
  }
}
