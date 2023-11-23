import 'dart:ui';

import 'package:flutter/material.dart' hide Image;

class AtlasesView extends StatelessWidget {
  const AtlasesView({
    required this.atlases,
    super.key,
  });

  final List<(String, Image)> atlases;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ColoredBox(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (final atlas in atlases) ...[
                Text(
                  atlas.$1,
                  style: const TextStyle(color: Colors.black),
                ),
                RawImage(image: atlas.$2),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
