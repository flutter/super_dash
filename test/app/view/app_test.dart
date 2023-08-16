import 'package:dash_run/app/app.dart';
import 'package:dash_run/game/game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders GameView', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(GameView), findsOneWidget);
    });
  });
}
