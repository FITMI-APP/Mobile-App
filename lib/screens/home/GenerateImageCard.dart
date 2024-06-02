import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../shared/loading.dart';
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
  bool isLoading = false; // Loading state
  http.Response? generatedImageResponse; // Response containing the generated image
  List<Uint8List> photos = []; // List to store photo data for recommendations
  List<Uint8List> complementaryPhotos = []; // List to store complementary items data
  bool photosFetched = false;
  bool complementaryPhotosFetched = false;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      await fetchGeneratedImage();
      await ServerReboot();
      //await fetchPhotos();
      //await fetchComplementaryPhotos();
    } catch (e) {
      print('Error in fetching data: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Error in fetching data: $e'),
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
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  Future<void> ServerReboot() async {
    try {
      var stopUrl = Uri.parse('http://192.168.1.2:6000/stop-server');
      var startUrl = Uri.parse('http://192.168.1.2:6000/start-server');

      var stopResponse = await http.get(stopUrl);
      if (stopResponse.statusCode == 200) {
        print('Server shut down');
      } else {
        print('Failed to shut down server');
      }

      var startResponse = await http.get(startUrl);
      if (startResponse.statusCode == 200) {
        print('Server started');
      } else {
        print('Failed to start server');
      }
    } catch (e) {
      print('Server reboot error: $e');
      throw 'Server reboot error: $e';
    }
  }

  Future<void> fetchGeneratedImage() async {
    try {
      var url = Uri.parse('http://192.168.1.2:5000/api/generate_tryon');
      var request = http.MultipartRequest('POST', url)
        ..fields['category'] = widget.category
        ..fields['gender'] = widget.gender
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
      if (response.statusCode == 200) {
        setState(() {
          generatedImageResponse = response;
        });
      } else {
        throw 'Failed to fetch generated image: ${response.statusCode}';
      }
    } catch (e) {
      print('Error fetching generated image: $e');
      throw 'Error fetching generated image: $e';
    }
  }

  Future<void> fetchPhotos() async {
    try {
      for (int i = 1; i <= 10; i++) {
        var url = Uri.parse('http://192.168.1.2:5000/get_cloth_rec?category=${widget.category}&id=$i');
        var response = await http.get(url);
        if (response.statusCode == 200) {
          setState(() {
            photos.add(response.bodyBytes);
          });
        } else {
          print('Failed to fetch photo: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error fetching photos: $e');
      throw 'Error fetching photos: $e';
    }
  }

  Future<void> fetchComplementaryPhotos() async {
    try {
      for (int i = 2; i <= 10; i++) {
        var url = Uri.parse('http://192.168.1.2:5000/get_comp_rec?gender=${widget.gender}&id=$i');
        var response = await http.get(url);
        if (response.statusCode == 200) {
          setState(() {
            complementaryPhotos.add(response.bodyBytes);
          });
        } else {
          print('Failed to fetch complementary photo: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error fetching complementary photos: $e');
      throw 'Error fetching complementary photos: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Generated Image Card', style: TextStyle(color: Colors.white)),
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
        automaticallyImplyLeading: !isLoading, // Disable back button when loading
      ),
      body: WillPopScope(
        onWillPop: () async => !isLoading, // Disable back button when loading
        child: isLoading
            ? Loading() // Show loading screen when isLoading is true
            : Center(
          child: SingleChildScrollView(
            child: Card(
              color: Color(0xFFF1EBF5),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5419d3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )// Custom hex color
                        ),
                        onPressed: () async {
                          if (!photosFetched) {
                            await fetchPhotos();
                            photosFetched = true;
                          }
                          setState(() {
                            showRecommendations = !showRecommendations;
                            showComplementaryItems = false;
                          });
                        },
                        child: Text('Recommend Cloth', style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5419d3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )// Custom hex color
                        ),
                        onPressed: () async {
                          if (!complementaryPhotosFetched) {
                            await fetchComplementaryPhotos();
                            complementaryPhotosFetched = true;
                          }
                          setState(() {
                            showComplementaryItems = !showComplementaryItems;
                            showRecommendations = false;
                          });
                        },
                        child: Text('Complementary Items', style: TextStyle(color: Colors.white)),
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
                color: Color(0xFFF1EBF5),
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
                                    if (imageUrl != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Added to wardrobe successfully."),
                                          backgroundColor: Color(0xFF3f1a8d),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF5419d3),
                                    shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      )
                                  ),
                                  child: Text(
                                    'Add to Wardrobe',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
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

    String? imageUrl = await WardrobeService().uploadImage(imageFile, userID, category);
    if (imageUrl != null) {
      await WardrobeService().saveImageUrlToDatabase(userID, category, imageUrl);
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
                color: Color(0xFFF1EBF5),
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
