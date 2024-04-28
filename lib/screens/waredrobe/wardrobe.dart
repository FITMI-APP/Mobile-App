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

  const ClothItems({
    Key? key,
    required this.category,
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
    // Implement your getUserInfo function here
    // For example, if _auth is your authentication object
    Map<String, String> userInfo = await _auth.getUserInfo();
    setState(() {
      _userId = userInfo['userid'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getImageUrlsByCategory(_userId, widget.category),
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
                          child: Image.network(
                            imageUrls[index],
                            width: 90,
                            height: 100,
                            fit: BoxFit.cover,
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Global key for the Scaffold

  File? uppercloth;
  File? lowercloth;
  File? dressescloth;
  final AuthService _auth = AuthService();
  String userID = '';

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
          appBar: Header(title: 'Wardrobe'),
          drawer: NavigationDrawerWidget(), // Attach the navigation drawer
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (userGender == 'female') // Conditionally show categories for woman
                  ...[
                    buildCategorySection(context, "Upper", uppercloth),
                    buildCategorySection(context, "Lower", lowercloth),
                    buildCategorySection(context, "Dresses", dressescloth),
                  ],
                if (userGender == 'male') // Conditionally show categories for man
                  ...[
                    buildCategorySection(context, "Upper", uppercloth),
                    buildCategorySection(context, "Lower", lowercloth),
                  ],
              ],
            ),
          ),
        );
      },
    );
  }


  Widget buildCategorySection(BuildContext context, String categoryTitle, File? clothFile) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoryTitle,
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
      ), // Example list of items
        ],
      ),
    );
  }

  // void getImage({required ImageSource source, required String category}) async {
  //   final file = await ImagePicker().pickImage(
  //     source: source,
  //     maxWidth: 640,
  //     maxHeight: 480,
  //     imageQuality: 70,
  //   );
  //   if (file != null) {
  //     setState(() {
  //       switch (category) {
  //         case 'Upper':
  //           uppercloth = File(file.path);
  //           break;
  //         case 'Lower':
  //           lowercloth = File(file.path);
  //           break;
  //         case 'Dresses':
  //           dressescloth = File(file.path);
  //           break;
  //         default:
  //           break;
  //       }
  //     });
  //   }
  // }

  Future<void> uploadImageToFirebase(File imageFile, String category) async {
    Map<String, String> userInfo = await _auth.getUserInfo();
    userID = userInfo['userid'] ?? '';

    String? imageUrl = await uploadImage(imageFile, userID, category);
    if (imageUrl != null) {
      await saveImageUrlToDatabase(userID, category, imageUrl);
      setState(() {});
    } else {
      print('Image upload failed');
    }
  }
}
Future<void> getImageUrlsForUserAndCategory(String userId, String category) async {
  List<String> imageUrls = await getImageUrlsByCategory(userId, category);
  if (imageUrls.isNotEmpty) {
    // Print or use the retrieved image URLs
    print('Image URLs for user $userId and category $category: $imageUrls');
  } else {
    print('No image URLs found for user $userId and category $category');
  }
}
