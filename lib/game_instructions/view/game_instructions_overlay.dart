import 'package:dash_run/game_instructions/routes/routes.dart';
import 'package:dash_run/game_instructions/widgets/widgets.dart';
import 'package:dash_run/gen/assets.gen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GameInstruction extends Equatable {
  const GameInstruction({
    required this.title,
    required this.description,
    required this.image,
  });

  final String title;
  final String description;
  final Widget image;

  @override
  List<Object> get props => [title, description, image];
}

class GameInstructionsOverlay extends StatelessWidget {
  const GameInstructionsOverlay({super.key});

  static PageRoute<void> route() {
    return HeroDialogRoute(
      builder: (_) => const GameInstructionsOverlay(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final instructions = [
      GameInstruction(
        title: 'Dash Auto-runs',
        description:
            'Welcome to Super Dash. In this game Dash runs automatically.',
        image: Assets.images.autoRunInstruction.image(),
      ),
      GameInstruction(
        title: 'Tap to Jump',
        description: 'Tap the screen to make Dash jump.',
        image: Assets.images.tapToJumpInstruction.image(),
      ),
      GameInstruction(
        title: 'Collect Eggs & Acorns',
        description: 'Get points by collecting eggs and acorns in the stage.',
        image: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Assets.images.egg.image(),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Assets.images.acorn.image(),
            ),
          ],
        ),
      ),
      GameInstruction(
        title: 'Powerful Wings',
        description:
            'Collect the golden feather to power up Dash with Flutter. While in midair, tap to do a double jump and see Dash fly!',
        image: Assets.images.autoRunInstruction.image(),
      ),
      GameInstruction(
        title: 'Level Gates',
        description:
            'Advance through gates to face tougher challenges at higher stages.',
        image: Assets.images.autoRunInstruction.image(),
      ),
      GameInstruction(
        title: 'Avoid Bugs',
        description:
            'No one likes bugs! Jump to dodge them and avoid taking damage.',
        image: Assets.images.autoRunInstruction.image(),
      ),
    ];

    return PageView.builder(
      itemCount: instructions.length,
      itemBuilder: (context, index) {
        final instruction = instructions.elementAt(index);
        return GameCard(
          title: instruction.title,
          description: instruction.description,
          image: instruction.image,
        );
      },
    );
  }
}
