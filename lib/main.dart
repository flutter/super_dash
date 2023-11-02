import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:super_dash/app/app.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/bootstrap.dart';
import 'package:super_dash/settings/persistence/persistence.dart';
import 'package:super_dash/settings/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = SettingsController(
    persistence: LocalStorageSettingsPersistence(),
  );

  final audio = AudioController()..attachSettings(settings);

  await audio.initialize();

  unawaited(
    bootstrap(
      () => App(
        audioController: audio,
        settingsController: settings,
      ),
    ),
  );
}
