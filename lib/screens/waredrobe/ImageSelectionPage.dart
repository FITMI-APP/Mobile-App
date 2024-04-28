import 'package:flutter/material.dart';
import 'package:grad/shared/Header.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../widget/navigation_drawer_widget.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Create a GlobalKey for the Scaffold

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add Item to ${widget.category}'),
      ),
      drawer: NavigationDrawerWidget(), // Dummy drawer implementation
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_image.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
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
              if (_imageFile == null)
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => getImage(ImageSource.camera),
                      child: Text('Capture Image'),
                    ),
                    ElevatedButton(
                      onPressed: () => getImage(ImageSource.gallery),
                      child: Text('Select Image'),
                    ),
                  ],
                ),
              if (_imageFile != null)
                ElevatedButton(
                  onPressed: removeImage,
                  child: Text('Remove Image'),
                ),
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
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Save image'),
              ),
            ],
          ),
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
      widget.onImageSelected(_imageFile); // Notify the parent about the selected image
    });
  }

  void removeImage() {
    setState(() {
      _imageFile = null;
      widget.onImageSelected(null); // Notify the parent about image removal
    });
  }
}