import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_card/image_card.dart';
import '../../shared/Header.dart';
import '../../shared/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GenerateImageCard extends StatefulWidget {

  final String gender;
  final String category;
  final String personImageName;
  final String clothImageName;
  final http.Response? generatedImageResponse;

  const GenerateImageCard({
    Key? key,
    required this.gender,
    required this.category,
    required this.personImageName,
    required this.clothImageName,
    this.generatedImageResponse,
  }) : super(key: key);
  @override
  _GenerateImageCardState createState() => _GenerateImageCardState();
}

class _GenerateImageCardState extends State<GenerateImageCard> {
  bool showRecommendations = false;
  // http.Response? generatedImageResponse;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#3F72AF"),
      appBar: AppBar(
        title: Text('Image Card'),
      ),
      body: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 20), // Adding space at the top
              FillImageCard(
                width: 250,
                heightImage: 250,
                imageProvider: widget.generatedImageResponse != null
                    ? MemoryImage(widget.generatedImageResponse!.bodyBytes) // Use generated image response
                    : AssetImage('assets/logoo.png'), // Fallback to default image
              ),
              SizedBox(height: 20), // Adding space between image and buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to home page
                      Navigator.pop(context);
                    },
                    child: Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showRecommendations = !showRecommendations;
                      });
                    },
                    child: Text('Recommend Other Cloth'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (showRecommendations)
                RecommendationSection(),// Adding space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}

class FillImageCard extends StatelessWidget {
  final double width;
  final double heightImage;
  final ImageProvider imageProvider;
  //final Widget title;
  // final Widget description;

  const FillImageCard({
    required this.width,
    required this.heightImage,
    required this.imageProvider,
    // required this.title,
    // required this.description,
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
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //  // child: title,
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   //child: description,
          // ),
        ],
      ),
    );
  }
}

class RecommendationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10, // Number of cards you want to show
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                width: 150,
                height: 150,
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