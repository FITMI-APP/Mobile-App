import 'package:flutter/material.dart';
import 'package:grad/services/authenticate.dart';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';



class Home extends StatefulWidget {

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  File? cloth;

  File? person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        elevation: 0,
        title: const Text('Fluttora'),
        actions: [
          TextButton.icon(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black)),
              onPressed: () async {
                await _auth.signOut();
              },
              icon: const Icon(Icons.person),
              label: const Text('Logout'))
        ],
      ),


      body: Column(
        //padding: const EdgeInsets.all(12.0),
        children: [
          Row(
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

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //You can populate it with different types of widgets like Icon
                AnimatedButtonBar(
                  radius: 32.0,
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.blueGrey.shade800,
                  foregroundColor: Colors.blueGrey.shade300,
                  elevation: 24,
                  borderColor: Colors.white,
                  borderWidth: 2,
                  innerVerticalPadding: 16,
                  children: [
                    ButtonBarEntry(onTap: () => print('First item tapped'), child: Text("woman")),
                    ButtonBarEntry(onTap: () => print('Second item tapped'), child: Text("men")),
                  ],
                ),
                //inverted selection button bar
                AnimatedButtonBar(
                  radius: 8.0,
                  padding: const EdgeInsets.all(16.0),
                  invertedSelection: true,
                  children: [
                    ButtonBarEntry(onTap: () => print('First item tapped'), child: Text('upper')),
                    ButtonBarEntry(onTap: () => print('Second item tapped'), child: Text('lower')),
                    ButtonBarEntry(onTap: () => print('Third item tapped'), child: Text('dress')),

                  ],
                ),
              ],
            ),
          )
        ],
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
