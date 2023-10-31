import 'package:dash_run/app/app.dart';
import 'package:dash_run/audio/audio.dart';
import 'package:dash_run/game/game.dart';
import 'package:dash_run/settings/settings_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSettingsController extends Mock implements SettingsController {}

class _MockAudioController extends Mock implements AudioController {}

void main() {
  group('App', () {
    testWidgets('renders GameView', (tester) async {
      await tester.pumpWidget(
        App(
          settingsController: _MockSettingsController(),
          audioController: _MockAudioController(),
        ),
      );
      expect(find.byType(GameView), findsOneWidget);
    });
  });
}
