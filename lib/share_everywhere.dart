import 'package:flutter/material.dart';
import 'package:share_everywhere/popup_item.dart';
import 'package:share_everywhere/url_generator_strategy.dart';

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

  ShareController({required this.networks});
}

class ShareButton extends StatefulWidget {
  final ShareController controller;
  final String url;
  final String? subject;
  final Widget? child;
  final Widget? icon;

  ShareButton(this.controller, this.url, {this.subject, this.child, this.icon})
      : assert(
          !(child != null && icon != null),
          'You can only pass [child] or [icon], not both.',
        );

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  List<Widget> currentIcons = [];

  ValueNotifier<Widget?> iconNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    currentIcons = widget.controller.networks.map((network) => network.icon).toList();
  }

  Future<void> _share(BuildContext context, SocialConfig network) async {
    await network.urlGenerator.launchURL(widget.url, subject: widget.subject);
    network.afterPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (BuildContext context) {
          return List.generate(widget.controller.networks.length, (index) {
            final network = widget.controller.networks[index];
            var currentIcon = ValueNotifier<Widget>(currentIcons[index]);
            return PopupItem<SocialConfig>(
              value: network,
              onTap: () async {
                await _share(context, network);
                currentIcon.value = network.newIcon ?? currentIcon.value;
              },
              child: ValueListenableBuilder<Widget>(
                valueListenable: currentIcon,
                builder: (BuildContext context, Widget value, Widget? child) {
                  return value;
                },
              ),
            );
          }).toList();
        },
        icon: (widget.child == null && widget.icon == null) ? const Icon(Icons.share) : null,
        child: widget.child);
  }
}
