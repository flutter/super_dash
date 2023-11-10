import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:dash_run/app_lifecycle/app_lifecycle.dart';
import 'package:dash_run/audio/audio.dart';
import 'package:dash_run/game_intro/game_intro.dart';
import 'package:dash_run/l10n/l10n.dart';
import 'package:dash_run/map_tester/map_tester.dart';
import 'package:dash_run/settings/settings.dart';
import 'package:dash_run/share/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

class App extends StatelessWidget {
  const App({
    required this.audioController,
    required this.settingsController,
    required this.shareController,
    required this.authenticationRepository,
    required this.leaderboardRepository,
    this.isTesting = false,
    super.key,
  });

  final bool isTesting;
  final AudioController audioController;
  final SettingsController settingsController;
  final ShareController shareController;
  final AuthenticationRepository authenticationRepository;
  final LeaderboardRepository leaderboardRepository;

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AudioController>(
            create: (context) {
              final lifecycleNotifier =
                  context.read<ValueNotifier<AppLifecycleState>>();
              return audioController
                ..attachLifecycleNotifier(lifecycleNotifier);
            },
            lazy: false,
          ),
          RepositoryProvider<SettingsController>.value(
            value: settingsController,
          ),
          RepositoryProvider<ShareController>.value(
            value: shareController,
          ),
          RepositoryProvider<AuthenticationRepository>.value(
            value: authenticationRepository..signInAnonymously(),
          ),
          RepositoryProvider<LeaderboardRepository>.value(
            value: leaderboardRepository,
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
            textTheme: AppTextStyles.textTheme,
          ),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: isTesting ? const MapTesterView() : const GameIntroPage(),
        ),
      ),
    );
  }
}
