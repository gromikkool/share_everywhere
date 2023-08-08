import 'package:flutter/material.dart';
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

  SocialConfig.internal({required Widget icon})
      : this(urlGenerator: InternalUrlGenerator(), type: 'Share to', icon: icon);

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
  final Widget? btn;

  ShareController({this.dlgTitle, required this.networks, this.btn});
}

class ShareButton extends StatefulWidget {
  final ShareController controller;
  final String url;

  ShareButton(this.controller, this.url);

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  List<Widget> currentIcons = [];

  @override
  void initState() {
    super.initState();
    currentIcons = widget.controller.networks.map((network) => network.icon).toList();
  }

  void _share(BuildContext context, SocialConfig network) {
    var _url = network.urlGenerator.generateUrl(widget.url);
    if (Theme.of(context).platform == TargetPlatform.android || Theme.of(context).platform == TargetPlatform.iOS) {
      Share.share(_url);
    } else {
      network.urlGenerator.launchURL(_url);
      network.afterPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (BuildContext context) {
          return List.generate(widget.controller.networks.length, (index) {
            final network = widget.controller.networks[index];
            var currentIcon = currentIcons[index];
            return PopupMenuItem<SocialConfig>(
              value: network,
              child: StatefulBuilder(builder: (context, setState) {
                return GestureDetector(
                    onTap: () {
                      _share(context, network);
                      setState(() {
                        currentIcon = network.newIcon ?? currentIcon;
                        print(currentIcons[index]);
                      });
                    },
                    child: currentIcon);
              }),
            );
          }).toList();
        },
        child: widget.controller.btn ??
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.share), Text('Share')],
            ));
  }
}
