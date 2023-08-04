import 'package:flutter/material.dart';
import 'package:share_everywhere/share_everywhere.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ShareController shareController = ShareController(
    dlgTitle: "Share on:",
    elevatedButtonText: Text("Share"),
    networks: [
      SocialConfig.facebook(
          icon: Image.asset(
            'icons/facebook.png',
            package: 'share_everywhere',
            width: kMinInteractiveDimension / 1.5,
            height: kMinInteractiveDimension / 1.5,
          ),
          appId: "your-facebook-app-id"),
      SocialConfig.linkedin(
        icon: Image.asset(
          'icons/linkedin.png',
          package: 'share_everywhere',
          width: kMinInteractiveDimension / 1.5,
          height: kMinInteractiveDimension / 1.5,
        ),
      ),
      SocialConfig.twitter(
        icon: Image.asset(
          'icons/twitter.png',
          package: 'share_everywhere',
          width: kMinInteractiveDimension / 1.5,
          height: kMinInteractiveDimension / 1.5,
        ),
      ),
      SocialConfig.copyTo(
        icon: Center(
          child: Row(
            children: [Icon(Icons.share), Text('Copy Link')],
          ),
        ),
        newIcon: Center(
          child: Row(
            children: [Icon(Icons.real_estate_agent_rounded), Text('Copied')],
          ),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Click the share button below:',
            ),
            ShareButton(shareController, "https://example.com")
          ],
        ),
      ),
    );
  }
}
