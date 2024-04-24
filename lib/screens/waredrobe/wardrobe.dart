import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(Wardrobe());
}

class ClothItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10, // Number of cards you want to show
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey[200],
                child: Center(
                  child: Text('Image $index'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Wardrobe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Wardrobe',
      theme: ThemeData(
        primaryColor: HexColor("#3F72AF"), // Adjusted primary color
        scaffoldBackgroundColor: HexColor("#3F72AF"), // Adjusted background color
      ),
      home: WardrobeScreen(),
    );
  }
}

class WardrobeScreen extends StatefulWidget {
  @override
  _WardrobeScreenState createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  File? uppercloth;
  File? lowercloth;
  File? dressescloth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wardrobe'),
        backgroundColor: HexColor("#3F72AF"), // Set the app bar color
      ),
      backgroundColor: HexColor("#3F72AF"), // Set the background color of the Scaffold
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCategorySection(context, "Upper", uppercloth),
            buildCategorySection(context, "Lower", lowercloth),
            buildCategorySection(context, "Dresses", dressescloth),
          ],
        ),
      ),
    );
  }

  void getImage({required ImageSource source, required String category}) async {
    final file = await ImagePicker().pickImage(
      source: source,
      maxWidth: 640,
      maxHeight: 480,
      imageQuality: 70,
    );
    if (file != null) {
      setState(() {
        switch (category) {
          case 'Upper':
            uppercloth = File(file.path);
            break;
          case 'Lower':
            lowercloth = File(file.path);
            break;
          case 'Dresses':
            dressescloth = File(file.path);
            break;
          default:
          // Handle default case
            break;
        }
      });
    }
  }

  void removeCloth(String category) {
    setState(() {
      switch (category) {
        case 'Upper':
          uppercloth = null;
          break;
        case 'Lower':
          lowercloth = null;
          break;
        case 'Dresses':
          dressescloth = null;
          break;
        default:
        // Handle default case
          break;
      }
    });
  }

  void uploadImageToFirebase(File imageFile, String category) {
    // Implement Firebase storage upload here
    // Example: FirebaseStorage.instance.ref().child('path/to/image').putFile(imageFile);
    print('Uploading $category image to Firebase storage...');
  }

  Widget buildCategorySection(BuildContext context, String categoryTitle, File? clothfile) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoryTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Adjusted text color
                ),
              ),
              IconButton(
                onPressed: () {
                  // Navigate to a new page for image selection
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageSelectionPage(
                        category: categoryTitle,
                        onImageSelected: (File? file) {
                          setState(() {
                            switch (categoryTitle) {
                              case 'Upper':
                                uppercloth = file;
                                break;
                              case 'Lower':
                                lowercloth = file;
                                break;
                              case 'Dresses':
                                dressescloth = file;
                                break;
                              default:
                              // Handle default case
                                break;
                            }
                          });
                        },
                        onUploadToFirebase: (File? file) {
                          uploadImageToFirebase(file!, categoryTitle);
                        },
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.black, // Adjusted icon color
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClothItems(),
        ],
      ),
    );
  }
}

class ImageSelectionPage extends StatefulWidget {
  final String category;
  final Function(File?) onImageSelected;
  final Function(File?) onUploadToFirebase;

  ImageSelectionPage({
    required this.category,
    required this.onImageSelected,
    required this.onUploadToFirebase,
  });

  @override
  _ImageSelectionPageState createState() => _ImageSelectionPageState();
}

class _ImageSelectionPageState extends State<ImageSelectionPage> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item to ${widget.category}'),
        backgroundColor: HexColor("#3F72AF"), // Set the app bar color
      ),
      backgroundColor: HexColor("#3F72AF"), // Set the background color of the Scaffold
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(
              _imageFile!,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            )
                : Text(
              'No image selected',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                getImage(ImageSource.camera);
              },
              child: Text('Capture Image'),
            ),
            ElevatedButton(
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              child: Text('Select Image'),
            ),
            _imageFile != null
                ? ElevatedButton(
              onPressed: () {
                removeImage();
              },
              child: Text('Remove Image'),
            )
                : SizedBox(),
            ElevatedButton(
              onPressed: () {
                if (_imageFile != null) {
                  widget.onUploadToFirebase(_imageFile);
                  Navigator.pop(context);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('No Image Selected'),
                        content: Text('Please select an image first.'),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Add image'),
            ),
          ],
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 640,
      maxHeight: 480,
      imageQuality: 70,
    );
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
      widget.onImageSelected(_imageFile);
    });
  }

  void removeImage() {
    setState(() {
      _imageFile = null;
      widget.onImageSelected(null);
    });
  }
}
