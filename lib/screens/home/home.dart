import 'package:flutter/material.dart';
import 'package:grad/services/authenticate.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../shared/constants.dart';
import '../../shared/Header.dart';
import 'GenerateImageCard.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 // final AuthService _auth = AuthService();
  File? cloth;
  File? person;
  bool _isWomanSelected = true;
  List<bool> _isClothTypeSelected = [true, false, false];

  int _selectedIndex = 0;
  List<String> _buttonLabels = ['Woman', 'Man'];

  @override
  Widget build(BuildContext context) {
    Paint foregroundPaint = Paint()
      ..color = _isWomanSelected ? HexColor("#aec2e6") : Colors.black;
    return Scaffold(
      backgroundColor: HexColor("#3F72AF"),
      appBar: Header(),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: 10),
              // ToggleButtons for Gender Selection
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.0),
                    color: HexColor("#DBE2EF"),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isWomanSelected = true;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text(
                            'Woman',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _isWomanSelected
                                  ? Colors.black
                                  : HexColor("#aec2e6"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isWomanSelected = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text(
                            'Man',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // color: _isWomanSelected ? HexColor("#aec2e6") : Colors.black,
                              foreground: foregroundPaint,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 4),
              // ToggleButtons for Cloth Type Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isClothTypeSelected = [true, false, false];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.0),
                        color: _isClothTypeSelected[0]
                            ? HexColor("#DBE2EF")
                            : HexColor("#aec2e6"),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        'Upper',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isClothTypeSelected[0]
                              ? HexColor("#aec2e6")
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isClothTypeSelected = [false, true, false];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.0),
                        color: _isClothTypeSelected[1]
                            ? HexColor("#DBE2EF")
                            : HexColor("#aec2e6"),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        'Lower',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isClothTypeSelected[1]
                              ? HexColor("#aec2e6")
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isClothTypeSelected = [false, false, true];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.0),
                        color: _isClothTypeSelected[2]
                            ? HexColor("#DBE2EF")
                            : HexColor("#aec2e6"),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        'Dress',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isClothTypeSelected[2]
                              ? HexColor("#aec2e6")
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildImageWidget(
                image: person,
                onRemove: () => setState(() => person = null),
                onCapture: () =>
                    getImage(source: ImageSource.camera, type: 'person'),
                onSelect: () =>
                    getImage(source: ImageSource.gallery, type: 'person'),
                placeholderText: 'Input person image',
              ),
              const SizedBox(width: 20),
              buildImageWidget(
                image: cloth,
                onRemove: () => setState(() => cloth = null),
                onCapture: () =>
                    getImage(source: ImageSource.camera, type: 'cloth'),
                onSelect: () =>
                    getImage(source: ImageSource.gallery, type: 'cloth'),
                placeholderText: 'Input cloth image',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 60, // Adjust the height according to your preference
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GenerateImageCard()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(HexColor("#DBE2EF")),
                  ),
                  child: const Text(
                    'Generate',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getImage({required ImageSource source, required String type}) async {
    final file = await ImagePicker().pickImage(
      source: source,
      maxWidth: 640,
      maxHeight: 480,
      imageQuality: 70, //0 - 100
    );

    if (file?.path != null) {
      setState(() {
        if (type == 'person') {
          person = File(file!.path);
        } else if (type == 'cloth') {
          cloth = File(file!.path);
        }
      });
    }
  }

  // void generate(){
  //   const GenerateImageCard();
  // }

  Widget buildImageWidget({
    File? image,
    VoidCallback? onRemove,
    VoidCallback? onCapture,
    VoidCallback? onSelect,
    String placeholderText = '',
  }) {
    return image != null
        ? Column(
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
                  backgroundColor:
                      MaterialStateProperty.all<Color>(HexColor("#DBE2EF")),
                ),
                child: Expanded(
                  child: const Text('remove image',
                      style: TextStyle(fontSize: 12, color: Colors.black)),
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
                      child: Text(
                        placeholderText,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onCapture,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              HexColor("#DBE2EF")),
                        ),
                        child: const Text('Capture Image',
                            style:
                                TextStyle(fontSize: 12, color: Colors.black)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onSelect,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              HexColor("#DBE2EF")),
                        ),
                        child: const Text('Select Image',
                            style:
                                TextStyle(fontSize: 12, color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ), //SizedBox(width:20), // Add spacing between containers
            ],
          );
  }
}
