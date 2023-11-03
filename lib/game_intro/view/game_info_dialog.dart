import 'package:app_ui/app_ui.dart';
import 'package:dash_run/assets/assets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GameInfoDialog extends StatelessWidget {
  const GameInfoDialog({super.key});

  static PageRoute<void> route() {
    return HeroDialogRoute(
      builder: (_) => const GameInfoDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bodyStyle = AppTextStyles.bodyLarge;
    final linkStyle = AppTextStyles.bodyLarge.copyWith(
      color: const Color(0xFF9CECCD),
      decoration: TextDecoration.underline,
    );
    return AppDialog(
      border: Border.all(color: Colors.white24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(Assets.logo, width: 230),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Text(
                  'About Super Dash',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: bodyStyle,
                    children: [
                      const TextSpan(text: 'Learn '),
                      TextSpan(
                        text: 'how we build Super Dash',
                        style: linkStyle,
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      const TextSpan(
                        text: ' in Flutter and grab the ',
                      ),
                      TextSpan(
                        text: 'open source code.',
                        style: linkStyle,
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Other Links',
                  style: bodyStyle,
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    text: 'Flutter Games',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Privacy Policy',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Terms of Service',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
