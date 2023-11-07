import 'package:dash_run/app/app.dart';
import 'package:dash_run/audio/audio.dart';
import 'package:dash_run/game_intro/game_intro.dart';
import 'package:dash_run/settings/settings_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockAudioController extends Mock implements AudioController {}

class _MockSettingsController extends Mock implements SettingsController {}

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

void main() {
  group('App', () {
    late AudioController audioController;
    late SettingsController settingsController;
    late LeaderboardRepository leaderboardRepository;

    setUp(() {
      audioController = _MockAudioController();
      settingsController = _MockSettingsController();
      leaderboardRepository = _MockLeaderboardRepository();

      when(() => settingsController.muted).thenReturn(ValueNotifier(true));
    });

    testWidgets('renders GameIntroPage', (tester) async {
      await tester.pumpWidget(
        App(
          audioController: audioController,
          settingsController: settingsController,
          leaderboardRepository: leaderboardRepository,
        ),
      );
      expect(find.byType(GameIntroPage), findsOneWidget);
    });
  });
}
