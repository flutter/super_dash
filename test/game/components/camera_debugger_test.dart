import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:super_dash/game/game.dart';

class _TestGame extends FlameGame with HasKeyboardHandlerComponents {}

class _MockRawKeyUpEvent extends Mock implements RawKeyUpEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '';
  }
}

class _MockRawKeyDownEvent extends Mock implements RawKeyDownEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '';
  }
}

void main() {
  group('CameraDebugger', () {
    test('has the correct initial values', () {
      final cameraDebugger = CameraDebugger();
      expect(cameraDebugger.size, equals(Vector2.all(150)));
      expect(
        cameraDebugger.paint.color.value,
        equals(Colors.pink.withOpacity(0.5).value),
      );
      expect(cameraDebugger.priority, equals(100));
    });

    testWithGame(
      'moves up when W is pressed',
      _TestGame.new,
      (game) async {
        final cameraDebugger = CameraDebugger();
        await game.ensureAdd(cameraDebugger);

        final initialPosition = cameraDebugger.position.clone();

        final controller =
            cameraDebugger.firstChild<KeyboardListenerComponent>()!;

        final keyDown = _MockRawKeyDownEvent();
        when(() => keyDown.logicalKey).thenReturn(LogicalKeyboardKey.keyW);

        controller.onKeyEvent(keyDown, {LogicalKeyboardKey.keyW});

        cameraDebugger.update(0.1);

        final updatedPosition = cameraDebugger.position.clone();
        expect(updatedPosition.y, lessThan(initialPosition.y));

        // Should not move anymore when the key is released
        final keyUp = _MockRawKeyUpEvent();
        when(() => keyUp.logicalKey).thenReturn(LogicalKeyboardKey.keyW);

        controller.onKeyEvent(keyUp, {LogicalKeyboardKey.keyW});
        cameraDebugger.update(0.1);

        final finalPosition = cameraDebugger.position.clone();
        expect(finalPosition.y, equals(updatedPosition.y));
      },
    );

    testWithGame('moves down when S is pressed', _TestGame.new, (game) async {
      final cameraDebugger = CameraDebugger();
      await game.ensureAdd(cameraDebugger);

      final initialPosition = cameraDebugger.position.clone();

      final controller =
          cameraDebugger.firstChild<KeyboardListenerComponent>()!;

      final keyDown = _MockRawKeyDownEvent();
      when(() => keyDown.logicalKey).thenReturn(LogicalKeyboardKey.keyS);

      controller.onKeyEvent(keyDown, {LogicalKeyboardKey.keyS});

      cameraDebugger.update(0.1);

      final updatedPosition = cameraDebugger.position.clone();
      expect(updatedPosition.y, greaterThan(initialPosition.y));

      // Should not move anymore when the key is released
      final keyUp = _MockRawKeyUpEvent();
      when(() => keyUp.logicalKey).thenReturn(LogicalKeyboardKey.keyS);

      controller.onKeyEvent(keyUp, {LogicalKeyboardKey.keyS});
      cameraDebugger.update(0.1);

      final finalPosition = cameraDebugger.position.clone();
      expect(finalPosition.y, equals(updatedPosition.y));
    });

    testWithGame('moves left when A is pressed', _TestGame.new, (game) async {
      final cameraDebugger = CameraDebugger();
      await game.ensureAdd(cameraDebugger);

      final initialPosition = cameraDebugger.position.clone();

      final controller =
          cameraDebugger.firstChild<KeyboardListenerComponent>()!;

      final keyDown = _MockRawKeyDownEvent();
      when(() => keyDown.logicalKey).thenReturn(LogicalKeyboardKey.keyA);

      controller.onKeyEvent(keyDown, {LogicalKeyboardKey.keyA});

      cameraDebugger.update(0.1);

      final updatedPosition = cameraDebugger.position.clone();
      expect(updatedPosition.x, lessThan(initialPosition.x));

      // Should not move anymore when the key is released
      final keyUp = _MockRawKeyUpEvent();
      when(() => keyUp.logicalKey).thenReturn(LogicalKeyboardKey.keyA);

      controller.onKeyEvent(keyUp, {LogicalKeyboardKey.keyA});
      cameraDebugger.update(0.1);

      final finalPosition = cameraDebugger.position.clone();
      expect(finalPosition.x, equals(updatedPosition.x));
    });

    testWithGame('moves left when D is pressed', _TestGame.new, (game) async {
      final cameraDebugger = CameraDebugger();
      await game.ensureAdd(cameraDebugger);

      final initialPosition = cameraDebugger.position.clone();

      final controller =
          cameraDebugger.firstChild<KeyboardListenerComponent>()!;

      final keyDown = _MockRawKeyDownEvent();
      when(() => keyDown.logicalKey).thenReturn(LogicalKeyboardKey.keyD);

      controller.onKeyEvent(keyDown, {LogicalKeyboardKey.keyD});

      cameraDebugger.update(0.1);

      final updatedPosition = cameraDebugger.position.clone();
      expect(updatedPosition.x, greaterThan(initialPosition.x));

      // Should not move anymore when the key is released
      final keyUp = _MockRawKeyUpEvent();
      when(() => keyUp.logicalKey).thenReturn(LogicalKeyboardKey.keyD);

      controller.onKeyEvent(keyUp, {LogicalKeyboardKey.keyD});
      cameraDebugger.update(0.1);

      final finalPosition = cameraDebugger.position.clone();
      expect(finalPosition.x, equals(updatedPosition.x));
    });

    testWithGame('increases speed when M is pressed', _TestGame.new,
        (game) async {
      final cameraDebugger = CameraDebugger();
      await game.ensureAdd(cameraDebugger);

      final controller =
          cameraDebugger.firstChild<KeyboardListenerComponent>()!;

      final keyDown = _MockRawKeyDownEvent();
      when(() => keyDown.logicalKey).thenReturn(LogicalKeyboardKey.keyM);

      controller.onKeyEvent(keyDown, {LogicalKeyboardKey.space});

      cameraDebugger.update(0.1);

      expect(cameraDebugger.speed, equals(900));

      // Should not move anymore when the key is released
      final keyUp = _MockRawKeyUpEvent();
      when(() => keyUp.logicalKey).thenReturn(LogicalKeyboardKey.keyM);

      controller.onKeyEvent(keyUp, {LogicalKeyboardKey.keyM});
      cameraDebugger.update(0.1);

      expect(cameraDebugger.speed, equals(300));
    });
  });
}
