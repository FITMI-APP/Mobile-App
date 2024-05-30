import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import '../widget/navigation_drawer_widget.dart';
import '../shared/Header.dart';

class GenerateImageFromTextPage extends StatefulWidget {
  const GenerateImageFromTextPage({Key? key}) : super(key: key);

  @override
  _GenerateImageFromTextPageState createState() => _GenerateImageFromTextPageState();
}

class _GenerateImageFromTextPageState extends State<GenerateImageFromTextPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _launchURL() async {
    const url = 'https://nice-areas-marry.loca.lt/';

    try {
      await FlutterWebBrowser.openWebPage(url: url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Header(title: 'Generate Image from Text'),
      drawer: NavigationDrawerWidget(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Coming Soon....',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _launchURL,
              child: Text('Try it in our web app'),
            ),
          ],
        ),
      ),
    );
  }
}
