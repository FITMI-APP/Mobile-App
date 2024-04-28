import 'package:flutter/material.dart';
import '../widget/navigation_drawer_widget.dart';// Import the navigation drawer widget
import '../shared/Header.dart'; // Assuming Header is a custom app bar widget

class GenerateImageFromTextPage extends StatefulWidget {
  const GenerateImageFromTextPage({Key? key}) : super(key: key);

  @override
  _GenerateImageFromTextPageState createState() => _GenerateImageFromTextPageState();
}

class _GenerateImageFromTextPageState extends State<GenerateImageFromTextPage> {
  final TextEditingController _textController = TextEditingController();
  String? _generatedImage;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Create a GlobalKey for the Scaffold

  void _generateImage() {
    setState(() {
      if (_textController.text.isNotEmpty) {
        _generatedImage = 'https://via.placeholder.com/150';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the key to the Scaffold
      appBar: Header(title: 'Generate Image from Text'),
      drawer: NavigationDrawerWidget(), // Ensure this widget works
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter Text to Generate Image',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateImage,
              child: Text('Generate Image'),
            ),
            const SizedBox(height: 16),
            _generatedImage != null
                ? Image.network(_generatedImage!)
                : Text('No image generated.'),
          ],
        ),
      ),
    );
  }
}
