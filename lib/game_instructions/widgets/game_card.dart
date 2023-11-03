import 'package:app_ui/app_ui.dart';
import 'package:dash_run/game_instructions/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    required this.title,
    required this.description,
    required this.image,
    required this.pageController,
    super.key,
  });

  final String title;
  final String description;
  final Widget image;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      widthFactor: context.isSmall ? 0.9 : 0.4,
      child: Card(
        color: Colors.white24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 16,
              right: 16,
              child: GameIconButton(
                icon: Icons.close,
                onPressed: Navigator.of(context).pop,
              ),
            ),
            _CardContent(
              image: image,
              title: title,
              description: description,
              pageController: pageController,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({
    required this.image,
    required this.title,
    required this.description,
    required this.pageController,
  });

  final Widget image;
  final String title;
  final String description;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CardImage(image: image),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        GameInstructionNavigationControls(
          pageController: pageController,
        ),
      ],
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({
    required this.image,
  });

  final Widget image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 224,
      height: 224,
      child: TraslucentBackground(
        border: Border.all(
          color: Colors.white,
        ),
        gradient: const [
          Color(0xFFB1B1B1),
          Color(0xFF363567),
          Color(0xFFE2F8FA),
          Colors.white38,
        ],
        child: Positioned.fill(child: image),
      ),
    );
  }
}
