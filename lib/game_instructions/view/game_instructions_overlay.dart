import 'dart:ui' as ui;
import 'package:app_ui/app_ui.dart';
import 'package:dash_run/game_instructions/game_instructions.dart';
import 'package:dash_run/gen/assets.gen.dart';
import 'package:dash_run/l10n/l10n.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider(
      create: (context) => GameInstructionsCubit(),
      child: const GameInstructionsOverlayView(),
    );
  }
}

class GameInstructionsOverlayView extends StatefulWidget {
  const GameInstructionsOverlayView({super.key});

  @override
  State<GameInstructionsOverlayView> createState() =>
      _GameInstructionsOverlayViewState();
}

class _GameInstructionsOverlayViewState
    extends State<GameInstructionsOverlayView> {
  late final PageController pageController;

  List<GameInstruction> get instructions {
    final l10n = context.l10n;
    return [
      GameInstruction(
        title: l10n.gameInstructionsPageAutoRunTitle,
        description: l10n.gameInstructionsPageAutoRunDescription,
        image: Assets.images.autoRunInstruction.image(
          width: 190,
          height: 190,
        ),
      ),
      GameInstruction(
        title: l10n.gameInstructionsPageTapToJumpTitle,
        description: l10n.gameInstructionsPageTapToJumpDescription,
        image: Assets.images.tapToJumpInstruction.image(
          width: 190,
          height: 190,
        ),
      ),
      GameInstruction(
        title: l10n.gameInstructionsPageCollectEggsAcornsTitle,
        description: l10n.gameInstructionsPageCollectEggsAcornsDescription,
        image: Stack(
          children: [
            Positioned(
              top: 0,
              left: -10,
              child: Assets.images.acorn.image(
                width: 190,
                height: 190,
              ),
            ),
            Positioned(
              right: -15,
              bottom: 0,
              child: Assets.images.egg.image(
                width: 190,
                height: 190,
              ),
            ),
          ],
        ),
      ),
      GameInstruction(
        title: l10n.gameInstructionsPagePowerfulWingsTitle,
        description: l10n.gameInstructionsPagePowerfulWingsDescription,
        image: Assets.images.powerfulWingsInstruction.image(
          width: 190,
          height: 190,
        ),
      ),
      GameInstruction(
        title: l10n.gameInstructionsPageLevelGatesTitle,
        description: l10n.gameInstructionsPageLevelGatesDescription,
        image: Assets.images.levelGatesInstruction.image(
          width: 190,
          height: 190,
        ),
      ),
      GameInstruction(
        title: l10n.gameInstructionsPageAvoidBugsTitle,
        description: l10n.gameInstructionsPageAvoidBugsDescription,
        image: Assets.images.avoidBugsInstruction.image(
          width: 190,
          height: 190,
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: PageView.builder(
        controller: pageController,
        onPageChanged: context.read<GameInstructionsCubit>().updateStep,
        itemCount: instructions.length,
        itemBuilder: (context, index) {
          final instruction = instructions.elementAt(index);
          return GameCard(
            title: instruction.title,
            description: instruction.description,
            image: instruction.image,
            pageController: pageController,
          );
        },
      ),
    );
  }
}
