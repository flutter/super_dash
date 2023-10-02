/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/flying_character.png
  AssetGenImage get flyingCharacter =>
      const AssetGenImage('assets/images/flying_character.png');

  /// File path: assets/images/running_character.png
  AssetGenImage get runningCharacter =>
      const AssetGenImage('assets/images/running_character.png');

  /// File path: assets/images/tile_clouds_v01.png
  AssetGenImage get tileCloudsV01 =>
      const AssetGenImage('assets/images/tile_clouds_v01.png');

  /// File path: assets/images/tile_enemies_v1.png
  AssetGenImage get tileEnemiesV1 =>
      const AssetGenImage('assets/images/tile_enemies_v1.png');

  /// File path: assets/images/tile_forest_ground_v01.png
  AssetGenImage get tileForestGroundV01 =>
      const AssetGenImage('assets/images/tile_forest_ground_v01.png');

  /// File path: assets/images/tile_forest_trees_v01.png
  AssetGenImage get tileForestTreesV01 =>
      const AssetGenImage('assets/images/tile_forest_trees_v01.png');

  /// File path: assets/images/tile_gate_v1.png
  AssetGenImage get tileGateV1 =>
      const AssetGenImage('assets/images/tile_gate_v1.png');

  /// File path: assets/images/tile_ground_transition_v01.png
  AssetGenImage get tileGroundTransitionV01 =>
      const AssetGenImage('assets/images/tile_ground_transition_v01.png');

  /// File path: assets/images/tile_items_v1.png
  AssetGenImage get tileItemsV1 =>
      const AssetGenImage('assets/images/tile_items_v1.png');

  /// File path: assets/images/tile_mountain_ground_v01.png
  AssetGenImage get tileMountainGroundV01 =>
      const AssetGenImage('assets/images/tile_mountain_ground_v01.png');

  /// File path: assets/images/tile_plains_ground_v01.png
  AssetGenImage get tilePlainsGroundV01 =>
      const AssetGenImage('assets/images/tile_plains_ground_v01.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        flyingCharacter,
        runningCharacter,
        tileCloudsV01,
        tileEnemiesV1,
        tileForestGroundV01,
        tileForestTreesV01,
        tileGateV1,
        tileGroundTransitionV01,
        tileItemsV1,
        tileMountainGroundV01,
        tilePlainsGroundV01
      ];
}

class $AssetsTilesGen {
  const $AssetsTilesGen();

  /// File path: assets/tiles/flutter_runnergame_map_v02.tmx
  String get flutterRunnergameMapV02 =>
      'assets/tiles/flutter_runnergame_map_v02.tmx';

  /// File path: assets/tiles/tile_clouds_v01.tsx
  String get tileCloudsV01 => 'assets/tiles/tile_clouds_v01.tsx';

  /// File path: assets/tiles/tile_enemies_v1.tsx
  String get tileEnemiesV1 => 'assets/tiles/tile_enemies_v1.tsx';

  /// File path: assets/tiles/tile_forest_ground_v01.tsx
  String get tileForestGroundV01 => 'assets/tiles/tile_forest_ground_v01.tsx';

  /// File path: assets/tiles/tile_forest_trees_v01.tsx
  String get tileForestTreesV01 => 'assets/tiles/tile_forest_trees_v01.tsx';

  /// File path: assets/tiles/tile_gate_v1.tsx
  String get tileGateV1 => 'assets/tiles/tile_gate_v1.tsx';

  /// File path: assets/tiles/tile_ground_transition_v01.tsx
  String get tileGroundTransitionV01 =>
      'assets/tiles/tile_ground_transition_v01.tsx';

  /// File path: assets/tiles/tile_items_v1.tsx
  String get tileItemsV1 => 'assets/tiles/tile_items_v1.tsx';

  /// File path: assets/tiles/tile_mountain_ground_v01.tsx
  String get tileMountainGroundV01 =>
      'assets/tiles/tile_mountain_ground_v01.tsx';

  /// File path: assets/tiles/tile_plains_ground_v01.tsx
  String get tilePlainsGroundV01 => 'assets/tiles/tile_plains_ground_v01.tsx';

  /// List of all assets
  List<String> get values => [
        flutterRunnergameMapV02,
        tileCloudsV01,
        tileEnemiesV1,
        tileForestGroundV01,
        tileForestTreesV01,
        tileGateV1,
        tileGroundTransitionV01,
        tileItemsV1,
        tileMountainGroundV01,
        tilePlainsGroundV01
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsTilesGen tiles = $AssetsTilesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
