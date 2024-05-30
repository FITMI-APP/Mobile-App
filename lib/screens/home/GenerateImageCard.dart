import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../services/authenticate.dart';
import '../../services/wardrobeService.dart';


class GenerateImageCard extends StatefulWidget {
  final String userId;
  final String gender; // Gender of the person trying on the clothes
  final String category; // Category of the clothing item
  final File? personImageName; // Person's image file
  final File? clothImageName; // Clothing image file

  const GenerateImageCard({
    Key? key,
    required this.userId,
    required this.gender,
    required this.category,
    required this.personImageName,
    required this.clothImageName,
  }) : super(key: key);

  @override
  _GenerateImageCardState createState() => _GenerateImageCardState();
}

class _GenerateImageCardState extends State<GenerateImageCard> {
  bool showRecommendations = false;
  bool showComplementaryItems = false;
  http.Response? generatedImageResponse; // Response containing the generated image
  List<Uint8List> photos = []; // List to store photo data for recommendations
  List<Uint8List> complementaryPhotos = []; // List to store complementary items data

  @override
  void initState() {
    super.initState();
    // Call the function to fetch the generated image when the widget is initialized
    fetchGeneratedImage();
    // Call the function to fetch the photo data for recommendations after another delay
    fetchPhotos();
    // Call the function to fetch complementary photos after another delay
    fetchComplementaryPhotos();
  }

  // Function to call the API and fetch the generated image
  Future<void> fetchGeneratedImage() async {
    try {
      // Construct the API endpoint URL
      var url = Uri.parse('http://192.168.1.2:5000/api/generate_tryon'); // Update with your actual server URL
      // Create a multipart request
      var request = http.MultipartRequest('POST', url)
      // Add fields to the request (category and gender)
        ..fields['category'] = widget.category
        ..fields['gender'] = widget.gender
      // Add files to the request (person_image and cloth_image)
        ..files.add(http.MultipartFile(
          'person_image',
          widget.personImageName!.readAsBytes().asStream(),
          widget.personImageName!.lengthSync(),
          filename: 'person_image.jpg',
        ))
        ..files.add(http.MultipartFile(
          'cloth_image',
          widget.clothImageName!.readAsBytes().asStream(),
          widget.clothImageName!.lengthSync(),
          filename: 'cloth_image.jpg',
        ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Check if the response was successful (status code 200)
      if (response.statusCode == 200) {
        setState(() {
          generatedImageResponse = response;
        });
      } else {
        throw 'Failed to fetch generated image: ${response.statusCode}';
      }
    } catch (e) {
      // Handle errors
      print('Error fetching generated image: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch generated image. Error: $e'), // Display the actual error message
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Function to fetch photo data from the API for recommendations
  Future<void> fetchPhotos() async {
    try {
      for (int i = 1; i <= 10; i++) {
        var url = Uri.parse('http://192.168.1.2:5000/get_cloth_rec?category=${widget.category}&id=$i');
        var response = await http.get(url);

        if (response.statusCode == 200) {
          // If the request is successful, directly add the photo data to the list
          setState(() {
            this.photos.add(response.bodyBytes);
          });
        } else {
          // If the request fails, show an error message
          print('Failed to fetch photo: ${response.statusCode}');
        }
      }
    } catch (e) {
      // Handle any exceptions
      print('Error fetching photos: $e');
    }
  }

  // Function to fetch photo data for complementary items
  Future<void> fetchComplementaryPhotos() async {
    try {
      for (int i = 2; i <= 10; i++) {
        var url = Uri.parse('http://192.168.1.2:5000/get_comp_rec?gender=${widget.gender}&id=$i');
        var response = await http.get(url);

        if (response.statusCode == 200) {
          // If the request is successful, directly add the photo data to the list
          setState(() {
            this.complementaryPhotos.add(response.bodyBytes);
          });
        } else {
          // If the request fails, show an error message
          print('Failed to fetch complementary photo: ${response.statusCode}');
        }
      }
    } catch (e) {
      // Handle any exceptions
      print('Error fetching complementary photos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Generated Image Card'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 20),
                if (generatedImageResponse != null)
                  FillImageCard(
                    width: 250,
                    heightImage: 350,
                    imageProvider: MemoryImage(generatedImageResponse!.bodyBytes),
                  )
                else
                  Text("No image generated"),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showRecommendations = !showRecommendations;
                          showComplementaryItems = false;
                        });
                      },
                      child: Text('Recommend Other Cloth'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showComplementaryItems = !showComplementaryItems;
                          showRecommendations = false;
                        });
                      },
                      child: Text('Complementary Items'),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                if (showRecommendations)
                  RecommendationSection(
                    photos: photos,
                    userId: widget.userId,
                    category: widget.category,
                  ),
                if (showComplementaryItems)
                  ComplementarySection(
                    photos: complementaryPhotos,
                    userId: widget.userId,
                    category: widget.category,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget to display the generated image
class FillImageCard extends StatelessWidget {
  final double width;
  final double heightImage;
  final ImageProvider imageProvider;

  const FillImageCard({
    required this.width,
    required this.heightImage,
    required this.imageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: heightImage + 50,
      child: Column(
        children: [
          Image(
            image: imageProvider,
            width: width,
            height: heightImage,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

class RecommendationSection extends StatefulWidget {
  final List<Uint8List> photos;
  final String userId;
  final String category;

  const RecommendationSection({
    required this.photos,
    required this.userId,
    required this.category,
  });

  @override
  _RecommendationSectionState createState() => _RecommendationSectionState();
}

class _RecommendationSectionState extends State<RecommendationSection> {
  int? selectedIndex;
  final AuthService _auth = AuthService();
  String userID = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.photos.length,
        itemBuilder: (context, index) {
          final photoData = widget.photos[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Card(
              child: Container(
                width: 150,
                height: 150,
                color: Colors.grey[200],
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(
                        photoData,
                        fit: BoxFit.cover,
                        width: 150,
                        height: 150,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: $error');
                          return Center(child: Text('Error loading image'));
                        },
                      ),
                    ),
                    if (selectedIndex == index)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            width: 150,
                            height: 150,
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Create a temporary file from the selected photo data
                                  final tempDir = await getTemporaryDirectory();
                                  final tempFile = File('${tempDir.path}/temp_image.jpg');
                                  await tempFile.writeAsBytes(photoData);

                                  // Upload the image and save the URL to Firestore
                                  String? imageUrl = await uploadImageToFirebase(tempFile, widget.category);
                                  // if (imageUrl != null) {
                                  //   // Optionally, you can save the URL to Firestore here
                                  // }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                ),
                                child: Text(
                                  'Add to Wardrobe',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<String?> uploadImageToFirebase(File imageFile, String category) async {
    Map<String, String> userInfo = await _auth.getUserInfo();
    String userID = userInfo['userid'] ?? '';

    String? imageUrl = await uploadImage(imageFile, userID, category);
    if (imageUrl != null) {
      await saveImageUrlToDatabase(userID, category, imageUrl);
      setState(() {});
    } else {
      print('Image upload failed');
    }
    return imageUrl;
  }

}

class ComplementarySection extends StatefulWidget {
  final List<Uint8List> photos;
  final String userId;
  final String category;

  const ComplementarySection({
    required this.photos,
    required this.userId,
    required this.category,
  });

  @override
  _ComplementarySectionState createState() => _ComplementarySectionState();
}

class _ComplementarySectionState extends State<ComplementarySection> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.photos.length,
        itemBuilder: (context, index) {
          final photoData = widget.photos[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Card(
              child: Container(
                width: 150,
                height: 150,
                color: Colors.grey[200],
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(
                        photoData,
                        fit: BoxFit.cover,
                        width: 150,
                        height: 150,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: $error');
                          return Center(child: Text('Error loading image'));
                        },
                      ),
                    ),
                    if (selectedIndex == index)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            width: 150,
                            height: 150,
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Create a temporary file from the selected photo data
                                  final tempDir = await getTemporaryDirectory();
                                  final tempFile = File('${tempDir.path}/temp_image.jpg');
                                  await tempFile.writeAsBytes(photoData);

                                  // Upload the image and save the URL to Firestore
                                  String? imageUrl = await uploadImage(tempFile, widget.userId, widget.category);
                                  if (imageUrl != null) {
                                    await saveImageUrlToDatabase(widget.userId, widget.category, imageUrl);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                child: Text(
                                  'Add to Wardrobe',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
