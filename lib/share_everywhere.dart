import 'package:flutter/material.dart';
import 'package:share_everywhere/dialog_body.dart';
import 'package:share_everywhere/url_generator_strategy.dart';
import 'package:share_plus/share_plus.dart';

class SocialConfig {
  final String type;
  final String? appId;
  final Widget icon;
  final Widget? newIcon;
  final UrlGeneratorStrategy urlGenerator;
  final VoidCallback? afterPressed;

  SocialConfig(
      {required this.urlGenerator,
      required this.type,
      this.appId,
      required this.icon,
      this.afterPressed,
      this.newIcon});

  SocialConfig.facebook({required String appId, required Widget icon})
      : this(urlGenerator: FacebookUrlGenerator(appId), type: 'facebook', appId: appId, icon: icon);

  SocialConfig.twitter({required Widget icon}) : this(urlGenerator: TwitterUrlGenerator(), type: 'twitter', icon: icon);

  SocialConfig.linkedin({required Widget icon})
      : this(urlGenerator: LinkedinUrlGenerator(), type: 'linkedin', icon: icon);

  SocialConfig.copyTo({required Widget icon, Widget? newIcon, VoidCallback? afterPressed})
      : this(
            urlGenerator: CopyToClipboardUrlGenerator(),
            type: 'copyTo',
            icon: icon,
            newIcon: newIcon,
            afterPressed: afterPressed);
}

class ShareController {
  final List<SocialConfig> networks;
  final String? dlgTitle;
  final Text? elevatedButtonText;

  ShareController({this.dlgTitle, required this.networks, this.elevatedButtonText});
}

class ShareButton extends StatelessWidget {
  final ShareController controller;
  final String url;
  final Widget? icon;

  ShareButton(this.controller, this.url, {this.icon});

  void _share(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.android || Theme.of(context).platform == TargetPlatform.iOS) {
      Share.share(url);
    } else {
      print(url);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: controller.dlgTitle != null
                ? Text(
                    controller.dlgTitle!,
                    textAlign: TextAlign.center,
                  )
                : null,
            children: [
              DialogBody(controller, url),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return controller.elevatedButtonText != null
        ? IconButton(
            icon: icon ?? const Icon(Icons.share),
            onPressed: () => _share(context),
          )
        : ElevatedButton(
            onPressed: () => _share(context),
            child: Text("Share"),
          );
  }
}
