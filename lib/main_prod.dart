import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:super_dash/app/app.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/bootstrap.dart';
import 'package:super_dash/firebase_options_prod.dart';
import 'package:super_dash/settings/persistence/persistence.dart';
import 'package:super_dash/settings/settings.dart';
import 'package:super_dash/share/share.dart';

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
    gameUrl: 'https://superdash.flutter.dev/',
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
