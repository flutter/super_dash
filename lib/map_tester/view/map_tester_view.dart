import 'package:dash_run/game/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MapTesterView extends StatefulWidget {
  const MapTesterView({super.key});

  @override
  State<MapTesterView> createState() => _MapTesterViewState();
}

class _MapTesterViewState extends State<MapTesterView> {
  DashRunGame? game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 16),
            if (game == null)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    game = DashRunGame();
                  });
                },
                child: const Text('Load folder'),
              )
            else
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    game = null;
                  });
                },
                child: const Text('Unload'),
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
