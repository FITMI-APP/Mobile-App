import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';

class GenerateImageCard extends StatefulWidget {
  final String gender; // Gender of the person trying on the clothes
  final String category; // Category of the clothing item
  final File? personImageName; // Person's image file
  final File? clothImageName; // Clothing image file

  const GenerateImageCard({
    Key? key,
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
  http.Response? generatedImageResponse; // Response containing the generated image

  @override
  void initState() {
    super.initState();
    // Call the function to fetch the generated image when the widget is initialized
    fetchGeneratedImage();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Generated Image Card'),
      ),
      body: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 20),
              if (generatedImageResponse != null)
                FillImageCard(
                  width: 250,
                  heightImage: 250,
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
              if (showRecommendations) RecommendationSection(),
            ],
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

// Widget for recommendation section
class RecommendationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
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