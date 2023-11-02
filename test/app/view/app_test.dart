import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:super_dash/app/app.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/game_intro/game_intro.dart';
import 'package:super_dash/settings/settings_controller.dart';

class _MockSettingsController extends Mock implements SettingsController {}

class _MockAudioController extends Mock implements AudioController {}

void main() {
  group('App', () {
    late AudioController audioController;
    late SettingsController settingsController;

    setUp(() {
      audioController = _MockAudioController();
      settingsController = _MockSettingsController();

      when(() => settingsController.soundsOn).thenReturn(ValueNotifier(true));
    });

    testWidgets('renders GameIntroPage', (tester) async {
      await tester.pumpWidget(
        App(
          audioController: audioController,
          settingsController: settingsController,
        ),
      );
      expect(find.byType(GameIntroPage), findsOneWidget);
    });
  });
}
