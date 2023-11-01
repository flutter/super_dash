import 'package:app_ui/app_ui.dart';
import 'package:dash_run/game_instructions/cubit/game_instructions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameInstructionNavigationControls extends StatelessWidget {
  const GameInstructionNavigationControls({
    required this.pageController,
    super.key,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final step in GameInstructionsStep.values)
              _PageIndicator(step: step),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GameIconButton(
              icon: Icons.arrow_back,
              onPressed: () => pageController.previousPage(
                duration: kThemeAnimationDuration,
                curve: Curves.easeIn,
              ),
            ),
            const SizedBox(width: 24),
            GameIconButton(
              icon: Icons.arrow_forward,
              onPressed: () => pageController.nextPage(
                duration: kThemeAnimationDuration,
                curve: Curves.easeIn,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.step,
  });

  static const inactiveGradient = [
    Color(0xFFEEF0F2),
    Colors.white,
  ];

  static const activeGradient = [
    Color(0xFF9CECCD),
    Color(0xFF9CECCD),
  ];

  final GameInstructionsStep step;

  @override
  Widget build(BuildContext context) {
    final currentStep = context.select(
      (GameInstructionsCubit cubit) => cubit.state.currentStep,
    );
    return Container(
      width: step == currentStep ? 24 : 12,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: step == currentStep ? BoxShape.rectangle : BoxShape.circle,
        border: Border.all(color: Colors.white),
        borderRadius: step == currentStep ? BorderRadius.circular(10) : null,
        gradient: LinearGradient(
          colors: step == currentStep ? activeGradient : inactiveGradient,
        ),
      ),
    );
  }
}
