import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Wardrobe extends StatelessWidget {
  const Wardrobe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wardrobe'),
        backgroundColor: HexColor("#3F72AF"),
      ),
      backgroundColor: HexColor("#3F72AF"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCategorySection("Upper"),
            buildCategorySection("Lower"),
            buildCategorySection("Dresses"),
          ],
        ),
      ),
    );
  }

  Widget buildCategorySection(String categoryTitle) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          clothItems(),
        ],
      ),
    );
  }
}

class clothItems extends StatelessWidget {
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
                child:
                // Center(
                  // child: Text('Image $index'),
                  Image.asset(
                    'assets/logoo.png', // Replace 'assets/your_image.png' with the path to your image asset
                  ),
                //),
              ),
            ),
          );
        },
      ),
    );
  }
}