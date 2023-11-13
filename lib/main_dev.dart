import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_run/app/app.dart';
import 'package:dash_run/audio/audio.dart';
import 'package:dash_run/bootstrap.dart';
import 'package:dash_run/firebase_options_dev.dart';
import 'package:dash_run/settings/persistence/persistence.dart';
import 'package:dash_run/settings/settings.dart';
import 'package:dash_run/share/share.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final settings = SettingsController(
    persistence: LocalStorageSettingsPersistence(),
  );

  final audio = AudioController()..attachSettings(settings);

  await audio.initialize();

  final share = ShareController(
    gameUrl: 'https://endless-runner-9481713-383737.web.app/',
  );

  final leaderboardRepository = LeaderboardRepository(
    FirebaseFirestore.instance,
  );

  unawaited(
    bootstrap(
      (firebaseAuth) async {
        final authenticationRepository = AuthenticationRepository(
          firebaseAuth: firebaseAuth,
        );

        return App(
          audioController: audio,
          settingsController: settings,
          shareController: share,
          authenticationRepository: authenticationRepository,
          leaderboardRepository: leaderboardRepository,
        );
      },
    ),
  );
}
