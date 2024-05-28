import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../services/wardrobeService.dart';
import '../../shared/Header.dart';
import '../../widget/navigation_drawer_widget.dart';
import 'GenerateImageCard.dart';
import '../../services/authenticate.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart'; // Import path_provider

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
  List<String> imageUrls = [];
  String _userId = '';
  final AuthService _auth = AuthService();

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
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    Map<String, String> userInfo = await _auth.getUserInfo();
    setState(() {
      _userId = userInfo['userid'] ?? '';
    });
  }

  Future<File> downloadFile(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${tempDir.path}/$uniqueFileName');
      await file.writeAsBytes(bytes);
      return file;
    } else {
      throw Exception('Failed to download file');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Home'),
      drawer: NavigationDrawerWidget(),
      body: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage("assets/background_image.jpg"),
          //   fit: BoxFit.cover,
          // ),
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
            // Image widgets with consistent style
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the row horizontally
              crossAxisAlignment: CrossAxisAlignment.start, // Align items at the start vertically
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
                const SizedBox(width: 20), // Space between the images
                buildImageWidget(
                  image: cloth,
                  onRemove: () => setState(() => cloth = null),
                  onCapture: () =>
                      getImage(source: ImageSource.camera, type: 'cloth'),
                  onSelect: () =>
                      getImage(source: ImageSource.gallery, type: 'cloth'),
                  placeholderText: 'Cloth image',
                  onWardrobe: _showImageUrlsModal, // Pass the callback for Wardrobe button
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: 300,
                    child: ElevatedButton(
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
                                  "Please insert both person and cloth images."),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor("#DBE2EF"), // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0), // Adjust vertical padding as needed
                        child: Text(
                          "Generate",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black, // Change text color
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),


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
      innerVerticalPadding: 12,
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
    VoidCallback? onWardrobe, // Add this parameter for the Wardrobe button
  }) {
    return Column(
      children: [
        Container(
          width: 150,
          height: 200,
          decoration: BoxDecoration(
            color: image != null ? Colors.transparent : HexColor("#DBE2EF"),
            image: image != null
                ? DecorationImage(
              image: FileImage(image),
              fit: BoxFit.cover,
            )
                : null,
            border: Border.all(width: 5, color: Colors.black12),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: image == null
              ? Text(
            placeholderText,
            style: const TextStyle(fontSize: 20),
          )
              : null,
        ),
        const SizedBox(height: 20),
        if (image != null)
          ElevatedButton(
            style: buttonStyle, // Consistent style for all ElevatedButtons
            onPressed: onRemove,
            child: const Text("Remove Image"),
          )
        else ...[
          SizedBox(
            width: 150, // Adjust the width as needed
            height: 50, // Adjust the height as needed
            child: ElevatedButton(
              onPressed: onCapture,
              style: buttonStyle,
              child: const Text("Capture Image", textAlign: TextAlign.center),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150, // Adjust the width as needed
            height: 50, // Adjust the height as needed
            child: ElevatedButton(
              onPressed: onSelect,
              style: buttonStyle,
              child: const Text("Image from gallery", textAlign: TextAlign.center),
            ),
          ),
          if (onWardrobe != null) // Show "Wardrobe" button only if onWardrobe is provided
            Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  width: 150, // Adjust the width as needed
                  height: 50, // Adjust the height as needed
                  child: ElevatedButton(
                    onPressed: onWardrobe,
                    style: buttonStyle,
                    child: const Text("Wardrobe", textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
        ],
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
      setState(() => type == 'person' ? person = File(file.path) : cloth = File(file.path));
    }
  }

  // Function to fetch wardrobe images
  Future<void> fetchWardrobeImages() async {
    try {
      print("Fetching image URLs...");
      final List<String> urls = await getImageUrlsByCategory(_userId, category);
      setState(() {
        imageUrls = urls;
      });
      print("Fetched image URLs: $imageUrls");
    } catch (e) {
      print("Error fetching image URLs: $e");
      // Handle error gracefully
    }
  }

  void _showImageUrlsModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<void>(
          future: fetchWardrobeImages(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error fetching images.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: imageUrls.isEmpty
                    ? Center(
                  child: Text(
                    'No images are in the wardrobe.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
                    : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        try {
                          final File downloadedFile = await downloadFile(imageUrls[index]);
                          setState(() {
                            cloth = downloadedFile;
                          });
                        } catch (e) {
                          print('Error downloading file: $e');
                        }
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image: $error');
                            return Icon(Icons.error);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        );
      },
    ).then((value) {
      // Clear imageUrls when the modal is closed
      setState(() {
        imageUrls.clear();
      });
    });
  }
}
