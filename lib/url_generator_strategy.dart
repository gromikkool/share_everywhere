import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

abstract class UrlGeneratorStrategy {
  String generateUrl(String url);

  Future<void> launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(
        url,
        webOnlyWindowName: '_blank',
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}

class CopyToClipboardUrlGenerator extends UrlGeneratorStrategy {
  @override
  String generateUrl(String url) {
    return url;
  }

  @override
  Future<void> launchURL(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
  }
}

class FacebookUrlGenerator extends UrlGeneratorStrategy {
  final String? appId;

  FacebookUrlGenerator(this.appId);

  @override
  String generateUrl(String url) {
    return 'https://www.facebook.com/dialog/share?app_id=$appId&display=page&href=$url';
  }
}

class LinkedinUrlGenerator extends UrlGeneratorStrategy {
  @override
  String generateUrl(String url) {
    return 'https://www.linkedin.com/sharing/share-offsite/?url=$url';
  }
}

class TwitterUrlGenerator extends UrlGeneratorStrategy {
  @override
  String generateUrl(String url) {
    return 'https://twitter.com/intent/tweet?text=$url';
  }
}

class InternalUrlGenerator extends UrlGeneratorStrategy {
  @override
  String generateUrl(String url) {
    return url;
  }

  @override
  Future<void> launchURL(String url) async {
    await Share.share(url);
  }
}
