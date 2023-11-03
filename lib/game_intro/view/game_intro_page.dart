import 'package:app_ui/app_ui.dart';
import 'package:dash_run/constants/constants.dart';
import 'package:dash_run/game/game.dart';
import 'package:dash_run/game_intro/game_intro.dart';
import 'package:dash_run/gen/assets.gen.dart';
import 'package:dash_run/l10n/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GameIntroPage extends StatelessWidget {
  const GameIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: context.isSmall
                ? Assets.images.introBackgroundMobile.provider()
                : Assets.images.introBackgroundDesktop.provider(),
            fit: BoxFit.cover,
          ),
        ),
        child: isMobileWeb
            ? const _MobileWebNotAvailableIntroPage()
            : const _IntroPage(),
      ),
    );
  }

  bool get isMobileWeb =>
      kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
}

class _IntroPage extends StatelessWidget {
  const _IntroPage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            const Spacer(),
            Assets.images.gameLogo.image(
              width: context.isSmall ? 282 : 380,
            ),
            const Spacer(flex: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                l10n.gameIntroPageHeadline,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 32),
            GameElevatedButton(
              label: l10n.gameIntroPagePlayButtonText,
              onPressed: () => Navigator.of(context).push(GameView.route()),
            ),
            const Spacer(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AudioButton(),
                LeaderboardButton(),
                InfoButton(),
                HowToPlayButton(),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _MobileWebNotAvailableIntroPage extends StatelessWidget {
  const _MobileWebNotAvailableIntroPage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            const Spacer(),
            Assets.images.gameLogo.image(width: 282),
            const Spacer(flex: 4),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF0046ab),
              ),
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.mobile_off,
                size: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.mobileModeUnavailable,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.mobileModeUnavailableDescription,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const _BottomBar(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AudioButton(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.superDash,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  text: l10n.howItsMade,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrlString(Urls.githubRepo);
                    },
                ),
              ),
            ],
          ),
          const InfoButton(),
        ],
      ),
    );
  }
}
