import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

abstract class UrlGeneratorStrategy {
  String generateUrl(String path);

  Future<void> launchURL(String path, {String? subject}) async {
    final url = generateUrl(path);
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
  Future<void> launchURL(String path, {String? subject}) async {
    final url = generateUrl(path);
    await Clipboard.setData(ClipboardData(text: url));
  }
}

class FacebookUrlGenerator extends UrlGeneratorStrategy {
  final String? appId;

  FacebookUrlGenerator(this.appId);

  @override
  String generateUrl(String path) {
    return 'https://www.facebook.com/dialog/share?app_id=$appId&display=page&href=$path';
  }
}

class LinkedinUrlGenerator extends UrlGeneratorStrategy {
  @override
  String generateUrl(String path) {
    return 'https://www.linkedin.com/sharing/share-offsite/?url=$path';
  }
}

class TwitterUrlGenerator extends UrlGeneratorStrategy {
  @override
  String generateUrl(String path) {
    return 'https://twitter.com/intent/tweet?text=$path';
  }
}

class InternalUrlGenerator extends UrlGeneratorStrategy {
  @override
  String generateUrl(String url) {
    return url;
  }

  @override
  Future<void> launchURL(String path, {String? subject}) async {
    final url = generateUrl(path);
    await Share.share(url, subject: subject);
  }
}
