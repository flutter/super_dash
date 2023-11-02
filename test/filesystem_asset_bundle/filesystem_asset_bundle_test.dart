import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:super_dash/filesytem_asset_bundle/filesystem_asset_bundle.dart';

void main() {
  group('FileSystemAssetBundle', () {
    late Directory testDir;

    setUp(() {
      testDir = Directory.systemTemp.createTempSync(
        '_test_${DateTime.now().millisecondsSinceEpoch}',
      )..createSync();
    });

    tearDown(() {
      testDir.deleteSync(recursive: true);
    });

    test('loads assets from a directory', () async {
      File(path.join(testDir.path, 'test.txt')).writeAsStringSync('test');

      final bundle = FileSystemAssetBundle(testDir.path);
      final data = await bundle.loadString('test.txt');

      expect(data, equals('test'));
    });

    test('loads structured assets from a directory', () async {
      File(path.join(testDir.path, 'test.json'))
          .writeAsStringSync('{"name": "Dash"}');

      final bundle = FileSystemAssetBundle(testDir.path);
      final data = await bundle.loadStructuredData<dynamic>(
        'test.json',
        (value) async => jsonDecode(value),
      );

      expect(data, equals({'name': 'Dash'}));
    });
  });
}
