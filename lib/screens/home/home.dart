import 'package:flutter/material.dart';
import 'package:grad/services/authenticate.dart';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../shared/constants.dart';


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
      backgroundColor: HexColor("#3F72AF"),
      appBar: AppBar(
        leading: logo,
        backgroundColor: HexColor("#DBE2EF"),
        elevation: 0,
        title: const Text('FitMi'),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //You can populate it with different types of widgets like Icon
              AnimatedButtonBar(
                radius: 32.0,
                padding: const EdgeInsets.all(10.0),
                backgroundColor: HexColor("#aec2e6"),
                foregroundColor: HexColor("#DBE2EF"),
                //elevation: 24,
                borderColor: Colors.white,
                borderWidth: 2,
                innerVerticalPadding: 14,
                children: [
                  ButtonBarEntry(onTap: () => print('First item tapped'), child: Text("woman",style: const TextStyle(fontWeight: FontWeight.bold))),
                  ButtonBarEntry(onTap: () => print('Second item tapped'), child: Text("men", style: const TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              //inverted selection button bar
              const SizedBox(height: 4),

              AnimatedButtonBar(
                radius: 32.0,
                padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,20.0),
                //invertedSelection: true,
                backgroundColor: HexColor("#aec2e6"),
                foregroundColor: HexColor("#DBE2EF"),
                borderWidth: 2,
                innerVerticalPadding: 14,
                borderColor: Colors.white,
                children: [
                  ButtonBarEntry(onTap: () => print('First item tapped'), child: Text('upper')),
                  ButtonBarEntry(onTap: () => print('Second item tapped'), child: Text('lower')),
                  ButtonBarEntry(onTap: () => print('Third item tapped'), child: Text('dress')),

                ],
              ),

             // const SizedBox(width: 10),

            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildImageWidget(
                image: person,
                onRemove: () => setState(() => person = null),
                onCapture: () => getImage(source: ImageSource.camera, type: 'person'),
                onSelect: () => getImage(source: ImageSource.gallery, type: 'person'),
                placeholderText: 'Input person image',

              ),
              const SizedBox(width: 20),
              buildImageWidget(
                image: cloth,
                onRemove: () => setState(() => cloth = null),
                onCapture: () => getImage(source: ImageSource.camera, type: 'cloth'),
                onSelect: () => getImage(source: ImageSource.gallery, type: 'cloth'),
                placeholderText: 'Input cloth image',
               // backgroundColor: MaterialStateProperty.all<Color>(HexColor("#DBE2EF")),
              ),
              //const SizedBox(height: 40),
            ],
          ) ,
          const SizedBox(height: 20),
          Container(
            height: 60, // Adjust the height according to your preference
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30.0,10.0,30.0,10.0),
                child: ElevatedButton(
                  onPressed: generate,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(HexColor("#DBE2EF")),
                  ),
                  child: Text('Generate', style: TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }

  void getImage({required ImageSource source, required String type}) async {
    final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 640,
        maxHeight: 480,
        imageQuality: 70 //0 - 100
    );

    if(file?.path != null){
      setState(() {
        if (type == 'person') {
          person = File(file!.path);
        } else if (type == 'cloth') {
          cloth = File(file!.path);
        }
      });
    }
  }
  void generate() async {

  }

  Widget buildImageWidget({
    File? image,
    VoidCallback? onRemove,
    VoidCallback? onCapture,
    VoidCallback? onSelect,
    String placeholderText = '',

  }) {
    return image != null ? Column( // image is already inserted
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey,
            image: DecorationImage(
              image: FileImage(image),
              fit: BoxFit.cover,
            ),
            border: Border.all(width: 5, color: Colors.black),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: onRemove,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(HexColor("#DBE2EF")),
          ),
          child: Expanded(
            child: const Text('remove image', style: TextStyle(fontSize: 12, color: Colors.black)),
          ),
        ),
      ],
    )
        : Column(
      children: [
        Container(
          height: 300,
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Container(
                width: 150,
                height: 150,
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  color: HexColor("#DBE2EF"),
                  border: Border.all(width: 5, color: Colors.black12),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(placeholderText, style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: onCapture,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(HexColor("#DBE2EF")),
                  ),
                  child: const Text('Capture Image', style: TextStyle(fontSize: 12, color: Colors.black)),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSelect,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(HexColor("#DBE2EF")),

                  ),
                  child: const Text('Select Image', style: TextStyle(fontSize: 12 , color: Colors.black)),
                ),
              ),
            ],
          ),
        ), //SizedBox(width:20), // Add spacing between containers
      ],
    );
  }
}
