import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class FileSystemAssetBundle extends AssetBundle {
  FileSystemAssetBundle(this.rootPath);

  final String rootPath;

  @override
  Future<ByteData> load(String key) async {
    final filePath = path.join(rootPath, key);

    final file = File(filePath);

    return file.readAsBytesSync().buffer.asByteData();
  }

  @override
  Future<T> loadStructuredData<T>(
    String key,
    Future<T> Function(String value) parser,
  ) {
    return loadString(key).then(parser);
  }
}
