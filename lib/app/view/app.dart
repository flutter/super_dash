import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:super_dash/app_lifecycle/app_lifecycle.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/game_intro/game_intro.dart';
import 'package:super_dash/l10n/l10n.dart';
import 'package:super_dash/map_tester/map_tester.dart';
import 'package:super_dash/settings/settings.dart';
import 'package:super_dash/share/share.dart';

class App extends StatefulWidget {
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
  State<App> createState() => _AppState();

  static _AppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>();
}

class _AppState extends State<App> {
  Locale? _locale;
  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AudioController>(
            create: (context) {
              final lifecycleNotifier =
                  context.read<ValueNotifier<AppLifecycleState>>();
              return widget.audioController
                ..attachLifecycleNotifier(lifecycleNotifier);
            },
            lazy: false,
          ),
          RepositoryProvider<SettingsController>.value(
            value: widget.settingsController,
          ),
          RepositoryProvider<ShareController>.value(
            value: widget.shareController,
          ),
          RepositoryProvider<AuthenticationRepository>.value(
            value: widget.authenticationRepository..signInAnonymously(),
          ),
          RepositoryProvider<LeaderboardRepository>.value(
            value: widget.leaderboardRepository,
          ),
        ],
        child: MaterialApp(
          locale: _locale,
          theme: ThemeData(
            textTheme: AppTextStyles.textTheme,
          ),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home:
              widget.isTesting ? const MapTesterView() : const GameIntroPage(),
        ),
      ),
    );
  }
}
