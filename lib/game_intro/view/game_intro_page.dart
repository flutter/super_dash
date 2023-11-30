import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:super_dash/constants/constants.dart';
import 'package:super_dash/game/game.dart';
import 'package:super_dash/game_intro/game_intro.dart';
import 'package:super_dash/gen/assets.gen.dart';
import 'package:super_dash/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class GameIntroPage extends StatefulWidget {
  const GameIntroPage({super.key});

  @override
  State<GameIntroPage> createState() => _GameIntroPageState();
}

class _GameIntroPageState extends State<GameIntroPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(Assets.images.gameBackground.provider(), context);
  }

  void _onDownload() {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    launchUrl(Uri.parse(isAndroid ? Urls.playStoreLink : Urls.appStoreLink));
  }

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
            ? _MobileWebNotAvailableIntroPage(onDownload: _onDownload)
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            GameElevatedButton(
              label: l10n.gameIntroPagePlayButtonText,
              onPressed: () => Navigator.of(context).push(Game.route()),
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
  const _MobileWebNotAvailableIntroPage({
    required this.onDownload,
  });

  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            const Spacer(),
            Assets.images.gameLogo.image(width: 282),
            const Spacer(flex: 4),
            const SizedBox(height: 24),
            Text(
              l10n.downloadAppMessage,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            GameElevatedButton.icon(
              label: l10n.downloadAppLabel,
              icon: const Icon(
                Icons.download,
                color: Colors.white,
              ),
              onPressed: onDownload,
            ),
            const Spacer(),
            const BottomBar(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
