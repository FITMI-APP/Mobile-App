import 'package:flutter/material.dart';
import 'package:grad/shared/Header.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../widget/navigation_drawer_widget.dart';
import '../../shared/constants.dart';
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
    String categoryWithoutBody = widget.category.replaceAll('_body', ''); // Remove _body if it exists

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add Item to ${categoryWithoutBody} cloth', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                HexColor("#3f1a8d"),
                HexColor("#4e24ae"),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ), // Dummy drawer implementation
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Color(0xFFF1EBF5),

          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _imageFile != null
                    ? Image.file(
                  _imageFile!,
                  height: 500,
                  width: 350,
                  fit: BoxFit.cover,
                )
                    : Text(
                  'No image selected',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_imageFile == null)
                      _buildGradientIconButton(
                        icon: Icons.camera_alt,
                        onPressed: () => getImage(ImageSource.camera),
                        tooltip: 'Capture Image',
                      ),
                    if (_imageFile == null)
                      SizedBox(width: 30), // Ensure spacing is consistent
                    if (_imageFile == null)
                      _buildGradientIconButton(
                        icon: Icons.photo_library,
                        onPressed: () => getImage(ImageSource.gallery),
                        tooltip: 'Select Image',
                      ),
                    if (_imageFile != null)
                      _buildGradientIconButton(
                        icon: Icons.delete,
                        onPressed: removeImage,
                        tooltip: 'Remove Image',
                      ),
                    if (_imageFile != null)
                      SizedBox(width: 30), // Ensure spacing is consistent
                    if (_imageFile != null)
                      _buildGradientIconButton(
                        icon: Icons.save,
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
                        tooltip: 'Save Image',
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF300f78), Color(0xFF5419d3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        tooltip: tooltip,
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