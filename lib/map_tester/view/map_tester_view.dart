import 'package:dash_run/filesytem_asset_bundle/filesystem_asset_bundle.dart';
import 'package:dash_run/game/game.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

typedef GetDirectoryPath = Future<String?> Function();

class MapTesterView extends StatefulWidget {
  const MapTesterView({
    this.selectGameFolder = getDirectoryPath,
    super.key,
  });

  final GetDirectoryPath selectGameFolder;

  @override
  State<MapTesterView> createState() => _MapTesterViewState();
}

class _MapTesterViewState extends State<MapTesterView> {
  DashRunGame? game;
  String? rootPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 16),
            if (game == null)
              ElevatedButton(
                onPressed: () async {
                  final directory = await widget.selectGameFolder();
                  if (directory != null) {
                    setState(() {
                      rootPath = directory;
                      game = DashRunGame(
                        customBundle: FileSystemAssetBundle(directory),
                      );
                    });
                  }
                },
                child: const Text('Load folder'),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    onPressed: () {
                      setState(() {
                        game = DashRunGame(
                          customBundle: FileSystemAssetBundle(
                            rootPath!,
                          ),
                        );
                      });
                    },
                    child: const Text('Reload'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      game?.addCameraDebugger();
                    },
                    child: const Text('Seize camera control'),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Expanded(
              child: game == null
                  ? const SizedBox.shrink()
                  : GameWidget(game: game!),
            ),
          ],
        ),
      ),
    );
  }
}
