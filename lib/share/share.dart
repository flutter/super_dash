import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShareController {
  ShareController({required this.gameUrl});

  final String gameUrl;

  String _postContent(int score) {
    final formatter = NumberFormat('#,###');
    final scoreFormatted = formatter.format(score);

    return 'Seen the latest #FlutterGame? I scored $scoreFormatted on '
        '#SuperDash. Can you beat my score?';
  }

  String _twitterUrl(String content) =>
      'https://twitter.com/intent/tweet?text=$content $gameUrl';

  String facebookUrl(String content) =>
      'https://www.facebook.com/sharer.php?u=$gameUrl';

  String _encode(String content) =>
      content.replaceAll(' ', '%20').replaceAll('#', '%23');

  Future<bool> shareOnTwitter(int score) async {
    final content = _postContent(score);
    final url = _encode(_twitterUrl(content));
    return launchUrlString(url);
  }

  Future<bool> shareOnFacebook(int score) async {
    final content = _postContent(score);
    final url = _encode(facebookUrl(content));
    return launchUrlString(url);
  }

  Future<void> shareMobile(int score) async {
    final content = _postContent(score);
    await Share.share(content);
  }
}
