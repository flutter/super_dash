import 'package:dash_run/audio/audio.dart';
import 'package:dash_run/l10n/l10n.dart';
import 'package:dash_run/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAudioController extends Mock implements AudioController {}

class _MockSettingsController extends Mock implements SettingsController {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    AudioController? audioController,
    SettingsController? settingsController,
  }) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(
              value: audioController ?? _MockAudioController(),
            ),
            RepositoryProvider.value(
              value: settingsController ?? _MockSettingsController(),
            ),
          ],
          child: widget,
        ),
      ),
    );
  }
}
