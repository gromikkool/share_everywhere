import 'package:flutter/material.dart';
import 'package:share_everywhere/share_everywhere.dart';

class DialogBody extends StatefulWidget {
  final ShareController shareController;
  final String url;

  const DialogBody(this.shareController, this.url, {Key? key}) : super(key: key);

  @override
  State<DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  List<Widget> currentIcons = [];

  @override
  void initState() {
    super.initState();
    currentIcons = widget.shareController.networks.map((network) => network.icon).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.shareController.networks.length, (index) {
        final network = widget.shareController.networks[index];
        final currentIcon = currentIcons[index];

        String _url = network.urlGenerator.generateUrl(widget.url);
        return TextButton.icon(
          label: Text(''),
          icon: currentIcon,
          onPressed: () {
            network.urlGenerator.launchURL(_url);
            network.afterPressed?.call();
            setState(() {
              currentIcons[index] = network.newIcon ?? currentIcon;
            });
          },
        );
      }),
    );
  }
}
