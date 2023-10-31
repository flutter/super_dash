import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    required this.title,
    required this.description,
    required this.image,
    super.key,
  });

  final String title;
  final String description;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 72,
        horizontal: 24,
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: Colors.white24,
          child: Stack(
            children: [
              const Positioned(
                top: 24,
                right: 24,
                child: CloseButton(),
              ),
              _CardContent(
                image: image,
                title: title,
                description: description,
              ),
            ],
          ),
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
  });

  final Widget image;
  final String title;
  final String description;

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
            horizontal: 64,
          ),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
            ),
          ),
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
    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                ),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFB1B1B1),
                    Color(0xFF363567),
                    Color(0xFFE2F8FA),
                    Colors.white38,
                  ],
                ),
              ),
            ),
          ),
        ),
        image,
      ],
    );
  }
}
