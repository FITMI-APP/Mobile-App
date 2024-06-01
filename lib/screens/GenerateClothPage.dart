import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:grad/shared/Header.dart';
import 'package:grad/widget/navigation_drawer_widget.dart';
import 'package:hexcolor/hexcolor.dart';


class GenerateImageFromTextPage extends StatefulWidget {
  const GenerateImageFromTextPage({Key? key}) : super(key: key);

  @override
  _GenerateImageFromTextPageState createState() =>
      _GenerateImageFromTextPageState();
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
      appBar: Header(title: 'Generate Your Own Cloth', scaffoldKey: _scaffoldKey),
      drawer: NavigationDrawerWidget(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: 300,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Coming Soon....',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: HexColor("#4A2F7C"),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _launchURL,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          HexColor("#5419D3"),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all(Size(180, 50)),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
                        elevation: MaterialStateProperty.all(0),
                        shadowColor: MaterialStateProperty.all(Colors.grey.shade300),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                      child: Text(
                        'Try our Web App',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
