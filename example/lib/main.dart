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
    networks: [
      SocialConfig.copyTo(
        icon: Row(
          children: [Icon(Icons.share), Text('Copy Link')],
        ),
        newIcon: Row(
          children: [Icon(Icons.real_estate_agent_rounded), Text('Copied')],
        ),
      ),
      SocialConfig.internal(
        icon: Center(
          child: Row(
            children: [Icon(Icons.share), Text('Share to')],
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
