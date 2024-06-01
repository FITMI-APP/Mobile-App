import 'package:flutter/material.dart';
import 'package:grad/shared/Header.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../services/authenticate.dart';
import '../../services/wardrobeService.dart';
import '../../shared/loading.dart';
import '../../widget/navigation_drawer_widget.dart';
import 'ImageSelectionPage.dart';

void main() {
  runApp(Wardrobe());
}

class ClothItems extends StatefulWidget {
  final String category;
  final VoidCallback onImageDeleted;

  const ClothItems({
    Key? key,
    required this.category,
    required this.onImageDeleted,
  }) : super(key: key);

  @override
  _ClothItemsState createState() => _ClothItemsState();
}

class _ClothItemsState extends State<ClothItems> {
  String _userId = '';
  final AuthService _auth = AuthService();

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

  Future<List<String>> _fetchImageUrls() {
    return WardrobeService().getImageUrlsByCategory(_userId, widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _fetchImageUrls(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<String>? imageUrls = snapshot.data;
          if (imageUrls != null && imageUrls.isNotEmpty) {
            return SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[200],
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EnlargedImage(
                                    imageUrl: imageUrls[index],
                                    userId: _userId,
                                    category: widget.category,
                                    onImageDeleted: () {
                                      widget.onImageDeleted();
                                      setState(() {});
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Image.network(
                              imageUrls[index],
                              width: 90,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(child: Text('No image URLs found.'));
          }
        }
      },
    );
  }
}

class Wardrobe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Wardrobe',
      theme: ThemeData(
        primaryColor: HexColor("#3F72AF"),
        scaffoldBackgroundColor: HexColor("#3F72AF"),
      ),
      home: WardrobeScreen(), // Your main screen with the drawer
    );
  }
}

class WardrobeScreen extends StatefulWidget {
  @override
  _WardrobeScreenState createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File? uppercloth;
  File? lowercloth;
  File? dressescloth;
  final AuthService _auth = AuthService();
  String userID = '';

  void _refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _auth.getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading(); // Show loading indicator while fetching user info
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final userGender = snapshot.data?['gender'];

        print('from wardrobe $userGender');

        return Scaffold(
          key: _scaffoldKey, // Use the GlobalKey for the Scaffold
          appBar: Header(title: 'Wardrobe', scaffoldKey: _scaffoldKey), // Pass the scaffoldKey here
          drawer: NavigationDrawerWidget(), // Attach the navigation drawer
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (userGender == 'female') // Conditionally show categories for woman
                  ...[
                    buildCategorySection(context, "upper_body", uppercloth),
                    buildCategorySection(context, "lower_body", lowercloth),
                    buildCategorySection(context, "dresses", dressescloth),
                  ],
                if (userGender == 'male') // Conditionally show categories for man
                  ...[
                    buildCategorySection(context, "upper_body", uppercloth),
                    buildCategorySection(context, "lower_body", lowercloth),
                  ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildCategorySection(BuildContext context, String categoryTitle, File? clothFile) {
    // Function to get display text based on category
    String getDisplayText(String category) {
      switch (category) {
        case 'upper_body':
          return 'Upper';
        case 'lower_body':
          return 'Lower';
        case 'dresses':
          return 'Dresses';
        default:
          return category; // Default to the original category if no match found
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getDisplayText(categoryTitle), // Use the mapping function here
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageSelectionPage(
                        category: categoryTitle,
                        onImageSelected: (File? file) {
                          setState(() {
                            switch (categoryTitle) {
                              case 'upper_body':
                                uppercloth = file;
                                break;
                              case 'lower_body':
                                lowercloth = file;
                                break;
                              case 'dresses':
                                dressescloth = file;
                                break;
                              default:
                                break;
                            }
                          });
                        },
                        onUploadToFirebase: (File? file) => uploadImageToFirebase(file!, categoryTitle),
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClothItems(
            category: categoryTitle,
            onImageDeleted: _refreshPage,
          ), // Example list of items
        ],
      ),
    );
  }

  Future<void> uploadImageToFirebase(File imageFile, String category) async {
    Map<String, String> userInfo = await _auth.getUserInfo();
    userID = userInfo['userid'] ?? '';

    String? imageUrl = await WardrobeService().uploadImage(imageFile, userID, category);
    if (imageUrl != null) {
      await WardrobeService().saveImageUrlToDatabase(userID, category, imageUrl);
      setState(() {});
    } else {
      print('Image upload failed');
    }
  }
}

Future<void> getImageUrlsForUserAndCategory(String userId, String category) async {
  List<String> imageUrls = await WardrobeService().getImageUrlsByCategory(userId, category);
  if (imageUrls.isNotEmpty) {
    // Print or use the retrieved image URLs
    print('Image URLs for user $userId and category $category: $imageUrls');
  } else {
    print('No image URLs found for user $userId and category $category');
  }
}

class EnlargedImage extends StatelessWidget {
  final String imageUrl;
  final String userId;
  final String category;
  final VoidCallback onImageDeleted;

  const EnlargedImage({
    Key? key,
    required this.imageUrl,
    required this.userId,
    required this.category,
    required this.onImageDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool? confirmDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Image'),
                  content: Text('Are you sure you want to delete this image?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirmDelete == true) {
                await WardrobeService().deleteImageUrlFromDatabase(userId, category, imageUrl);
                onImageDeleted();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
