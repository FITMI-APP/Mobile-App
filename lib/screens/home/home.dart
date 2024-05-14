import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../shared/Header.dart';
import '../../widget/navigation_drawer_widget.dart';
import 'GenerateImageCard.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? cloth;
  File? person;
  String gender = 'female'; // Default selection
  String category = 'upper_body';

  // Define a consistent style for buttons
  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: HexColor("#F5F5F5"), // Button background color
    foregroundColor: Colors.black, // Button text color
    padding: const EdgeInsets.all(12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Home'),
      drawer: NavigationDrawerWidget(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_image.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gender selection button bar with consistent style
            buildAnimatedButtonBar([
              buildButtonBarEntry(
                  "woman", () => setState(() => gender = "female")),
              buildButtonBarEntry("man", () => setState(() => gender = "male")),
            ]),

            // Category selection button bar with consistent style
            buildAnimatedButtonBar([
              buildButtonBarEntry(
                  "upper", () => setState(() => category = "upper_body")),
              buildButtonBarEntry(
                  "lower", () => setState(() => category = "lower_body")),
              if (gender == 'female')
                buildButtonBarEntry(
                    "dress", () => setState(() => category = "dresses")),
            ]),

            const SizedBox(height: 10),

            // Image widgets with consistent style
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildImageWidget(
                  image: person,
                  onRemove: () => setState(() => person = null),
                  onCapture: () =>
                      getImage(source: ImageSource.camera, type: 'person'),
                  onSelect: () =>
                      getImage(source: ImageSource.gallery, type: 'person'),
                  placeholderText: 'Person image',
                ),
                const SizedBox(width: 20),
                buildImageWidget(
                  image: cloth,
                  onRemove: () => setState(() => cloth = null),
                  onCapture: () =>
                      getImage(source: ImageSource.camera, type: 'cloth'),
                  onSelect: () =>
                      getImage(source: ImageSource.gallery, type: 'cloth'),
                  placeholderText: 'Cloth image',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // "Generate" button with consistent style
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                if (person != null && cloth != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenerateImageCard(
                        gender: gender,
                        category: category,
                        personImageName: person,
                        clothImageName: cloth,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            "Please insert both person and cloth images.")),
                  );
                }
              },
                child: const Text(
                  "    Generate    ",
                ),
              ),

          ],
        ),
      ),
    );
  }

  // Helper method to build consistent animated button bars
  Widget buildAnimatedButtonBar(List<ButtonBarEntry> entries) {
    return AnimatedButtonBar(
      radius: 32.0,
      padding: const EdgeInsets.all(10.0),
      backgroundColor: HexColor("#DBE2EF"),
      foregroundColor: HexColor("#FFFFFF"),
      borderWidth: 2,
      innerVerticalPadding: 14,
      borderColor: Colors.white,
      children: entries,
    );
  }

  // Helper method to create consistent button bar entries
  ButtonBarEntry buildButtonBarEntry(String text, VoidCallback onTap) {
    return ButtonBarEntry(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  // Helper method to build image widgets with consistent styling
  Widget buildImageWidget({
    File? image,
    VoidCallback? onRemove,
    VoidCallback? onCapture,
    VoidCallback? onSelect,
    String placeholderText = '',
  }) {
    return image != null
        ? Column(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                    image: FileImage(image),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(width: 5, color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: buttonStyle, // Consistent style for all ElevatedButtons
                onPressed: onRemove,
                child: const Text("Remove Image"),
              ),
            ],
          )
        : Column(
            children: [
              Container(
                width: 150,
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: HexColor("#DBE2EF"),
                  border: Border.all(width: 5, color: Colors.black12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  placeholderText,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: buttonStyle,
                onPressed: onCapture,
                child: const Text("Capture Image"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: buttonStyle,
                onPressed: onSelect,
                child: const Text("Select Image"),
              ),
            ],
          );
  }

  // Helper method to get images from the camera or gallery
  void getImage({required ImageSource source, required String type}) async {
    final file = await ImagePicker().pickImage(
      source: source,
      maxWidth: 640,
      maxHeight: 480,
      imageQuality: 70, // Image quality (0 - 100)
    );

    if (file != null) {
      setState(() => type == 'person'
          ? person = File(file.path)
          : cloth = File(file.path));
    }
  }
}
