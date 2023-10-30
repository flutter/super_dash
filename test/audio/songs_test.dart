// ignore_for_file: prefer_const_constructors
import 'package:dash_run/audio/songs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Song', () {
    test('toString returns correctly', () {
      expect(
        Song('SONG.mp3', 'SONG').toString(),
        equals('Song<SONG.mp3>'),
      );
    });
  });
}
