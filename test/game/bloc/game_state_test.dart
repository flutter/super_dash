// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:super_dash/game/bloc/game_bloc.dart';

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
        GameState(score: 100, currentLevel: 1, currentSection: 0),
      );
    });

    test(
      'returns object with updated scocurrentLevelre when score is passed',
      () {
        expect(
          GameState.initial().copyWith(currentLevel: 2),
          GameState(score: 0, currentLevel: 2, currentSection: 0),
        );
      },
    );

    test('returns object with updated currentSection when score is passed', () {
      expect(
        GameState.initial().copyWith(currentSection: 3),
        GameState(score: 0, currentLevel: 1, currentSection: 3),
      );
    });
  });
}
