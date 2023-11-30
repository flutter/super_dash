import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_dash/filesytem_asset_bundle/filesystem_asset_bundle.dart';
import 'package:super_dash/game/game.dart';
import 'package:super_dash/map_tester/map_tester.dart';
import 'package:super_dash/settings/settings_controller.dart';

typedef GetDirectoryPath = Future<String?> Function();

Future<void> _defaultTimer() {
  return Future<void>.delayed(const Duration(milliseconds: 800));
}

class MapTesterView extends StatefulWidget {
  const MapTesterView({
    this.selectGameFolder = getDirectoryPath,
    this.timer = _defaultTimer,
    super.key,
  });

  final GetDirectoryPath selectGameFolder;
  final Future<void> Function() timer;

  @override
  State<MapTesterView> createState() => _MapTesterViewState();
}

class _MapTesterViewState extends State<MapTesterView> {
  SuperDashGame? game;
  String? rootPath;

  double? speed;
  double? jumpImpulse;

  @override
  void initState() {
    super.initState();

    final settings = context.read<SettingsController>();
    settings.muted.value = true;
    settings.musicOn.value = false;
    settings.soundsOn.value = false;
  }

  Future<void> _createGame() async {
    if (!kIsWeb && Platform.isMacOS) {
      final directory = await widget.selectGameFolder();
      if (directory != null) {
        setState(() {
          rootPath = directory;
          game = SuperDashGame(
            gameBloc: GameBloc(),
            customBundle: FileSystemAssetBundle(directory),
            audioController: context.read(),
            inMapTester: true,
          );
        });
      }
    } else {
      setState(() {
        game = SuperDashGame(
          gameBloc: GameBloc(),
          audioController: context.read(),
          inMapTester: true,
        );
      });
    }
  }

  Future<void> _reload() async {
    late SuperDashGame newGame;
    if (!kIsWeb && Platform.isMacOS) {
      newGame = SuperDashGame(
        gameBloc: GameBloc(),
        audioController: context.read(),
        customBundle: FileSystemAssetBundle(rootPath!),
        inMapTester: true,
      );
    } else {
      newGame = SuperDashGame(
        gameBloc: GameBloc(),
        audioController: context.read(),
        inMapTester: true,
      );
    }

    setState(() {
      game = newGame;
    });

    // So we know for sure that everything is loaded and added.
    await widget.timer();

    if (speed != null) {
      _setSpeed(speed!);
    }

    if (jumpImpulse != null) {
      _setJumpImpulse(jumpImpulse!);
    }
  }

  void _updateSpeed(double value) {
    setState(() {
      final newValue = (speed ?? Player.speed) + value;
      speed = newValue;
      _setSpeed(newValue);
    });
  }

  void _setSpeed(double newValue) {
    game?.player?.walkSpeed = newValue * (game?.tileSize ?? 0);
  }

  void _updateJumpImpulse(double value) {
    setState(() {
      final newValue = (jumpImpulse ?? Player.jumpImpulse) + value;
      jumpImpulse = newValue;
      _setJumpImpulse(newValue);
    });
  }

  void _setJumpImpulse(double newValue) {
    game?.player?.minJumpImpulse =
        (game?.player?.world.gravity ?? 0) * newValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: game == null
                  ? const SizedBox.shrink()
                  : GameWidget(game: game!),
            ),
            const SizedBox(height: 16),
            if (game == null)
              ElevatedButton(
                onPressed: _createGame,
                child: const Text('Load'),
              )
            else
              Column(
                children: [
                  Wrap(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            game = null;
                          });
                        },
                        child: const Text('Unload'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _reload,
                        child: const Text('Reload'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          game?.addCameraDebugger();
                        },
                        child: const Text('Seize camera control'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          game?.toggleInvincibility();
                        },
                        child: const Text('Toggle invincibility'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          game?.teleportPlayerToEnd();
                        },
                        child: const Text('Teleport to end'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          game?.showHitBoxes();
                        },
                        child: const Text('Show hitboxes'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          game?.player?.addPowerUp();
                        },
                        child: const Text('Add powerup'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<SettingsController>().toggleMuted();
                        },
                        child: const Text('Toggle sound'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          game?.player?.respawn();
                        },
                        child: const Text('Respawn'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          final atlases = game?.leapMap.tiledMap.atlases();
                          if (atlases != null) {
                            showDialog<void>(
                              context: context,
                              builder: (_) {
                                return AtlasesView(atlases: atlases);
                              },
                            );
                          }
                        },
                        child: const Text('View Atlases'),
                      ),
                    ],
                  ),
                  const Divider(),
                  Column(
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _updateSpeed(.2);
                            },
                            child: const Text('+'),
                          ),
                          _SpeedLabel(speed: speed),
                          ElevatedButton(
                            onPressed: () {
                              _updateSpeed(-.2);
                            },
                            child: const Text('-'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _updateJumpImpulse(.2);
                            },
                            child: const Text('+'),
                          ),
                          _JumpImpulseLabel(jumpImpulse: jumpImpulse),
                          ElevatedButton(
                            onPressed: () {
                              _updateJumpImpulse(-.2);
                            },
                            child: const Text('-'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SpeedLabel extends StatelessWidget {
  const _SpeedLabel({
    required this.speed,
  });

  final double? speed;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${(speed ?? Player.speed).toStringAsFixed(2)}'
      ' (Tiles per second)',
      style: const TextStyle(color: Colors.black),
    );
  }
}

class _JumpImpulseLabel extends StatelessWidget {
  const _JumpImpulseLabel({
    required this.jumpImpulse,
  });

  final double? jumpImpulse;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${(jumpImpulse ?? Player.jumpImpulse).toStringAsFixed(2)}'
      ' (Gravity %)',
      style: const TextStyle(color: Colors.black),
    );
  }
}
