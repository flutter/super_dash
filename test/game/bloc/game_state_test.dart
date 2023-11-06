// ignore_for_file: prefer_const_constructors

import 'package:dash_run/game/bloc/game_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameState', () {
    test(
      'initial state score is 0',
      () => expect(GameState.initial().score, isZero),
    );

    test('supports value comparisons', () {
      expect(GameState.initial(), GameState.initial());
    });

    test('returns same object when no properties are passed', () {
      expect(GameState.initial().copyWith(), GameState.initial());
    });

    test('returns object with updated score when score is passed', () {
      expect(
        GameState.initial().copyWith(score: 100),
        GameState(score: 100),
      );
    });
  });
}
