// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

const Set<Song> songs = {
  // Filenames with whitespace break package:audioplayers on iOS
  // (as of February 2022), so we use no whitespace.
  Song(
    'background.mp3',
    'SuperDash',
    artist: 'SuperDashMusic',
  ),
};

class Song {
  const Song(this.filename, this.name, {this.artist});

  final String filename;

  final String name;

  final String? artist;

  @override
  String toString() => 'Song<$filename>';
}
