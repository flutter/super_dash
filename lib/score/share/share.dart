import 'package:dash_run/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShareService {
  static String _postContent(int score) {
    final formatter = NumberFormat('#,###');
    final scoreFormatted = formatter.format(score);

    return 'Seen the latest #FlutterGame? I scored $scoreFormatted on '
        '#SuperDash. Can you beat my score?';
  }

  static String _twitterUrl(String content) =>
      'https://twitter.com/intent/tweet?text=$content';

  static String facebookUrl(String content) =>
      'https://www.facebook.com/sharer.php?u=${Urls.game}';

  static String _encode(String content) =>
      content.replaceAll(' ', '%20').replaceAll('#', '%23');

  static Future<bool> shareOnTwitter(int score) async {
    final content = _postContent(score);
    final url = _encode(_twitterUrl(content));
    return launchUrlString(url);
  }

  static Future<bool> shareOnFacebook(int score) async {
    final content = _postContent(score);
    final url = _encode(facebookUrl(content));
    return launchUrlString(url);
  }
}
