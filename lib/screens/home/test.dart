import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MaterialApp(
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _HomeState();
}

class _HomeState extends State<MyHomePage> {

  File? cloth;
  File? person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capturing Images'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(person != null )
              Row(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                          image: FileImage(person!),
                          fit: BoxFit.cover
                      ),
                      border: Border.all(width: 8, color: Colors.black),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),

                ],
              )
            else
              Row(
                children: [
                  Container(
                    height:250,
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(width: 8, color: Colors.black12),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Text('person should appear here', style: TextStyle(fontSize: 26)),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => getImage(source: ImageSource.camera),
                            child: const Text('Capture Image', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => getImage(source: ImageSource.gallery),
                            child: const Text('Select Image', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between containers
                ],
              ),




            const SizedBox(
              width: 20,
            ),





            if(cloth != null )
              Row(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(cloth!),
                          fit: BoxFit.cover
                      ),
                      border: Border.all(width: 8, color: Colors.black),
                      borderRadius: BorderRadius.circular(12.0),
                    ),

                  ),
                ],
              )

            else
              Row(
                children: [
                  Container(
                    height:250,
                    alignment: Alignment.topRight,
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          alignment: Alignment.topRight,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(width: 8, color: Colors.black12),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Text('cloth should appear here', style: TextStyle(fontSize: 26)),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => getcloth(source: ImageSource.camera),
                            child: const Text('Capture Image', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => getcloth(source: ImageSource.gallery),
                            child: const Text('Select Image', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between containers

                        ],
                      ),






            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void getImage({required ImageSource source}) async {

    final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 640,
        maxHeight: 480,
        imageQuality: 70 //0 - 100
    );

    if(file?.path != null){
      setState(() {
        person = File(file!.path);
      });
    }
  }
  void getcloth({required ImageSource source}) async {

    final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 640,
        maxHeight: 480,
        imageQuality: 70 //0 - 100
    );

    if(file?.path != null){
      setState(() {
        cloth = File(file!.path);
      });
    }
  }
}