import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../shared/constants.dart';
import '../../shared/Header.dart';
import '../../widget/button_widget.dart';
import '../../widget/navigation_drawer_widget.dart';
import 'GenerateImageCard.dart';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? cloth;
  File? person;
  String category = '';
  String gender = '';
  String? _selectedCategory;
  bool _isDropdownVisible = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: HexColor("#3F72AF"),
      drawer: NavigationDrawerWidget(),
      appBar: Header(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              AnimatedButtonBar(
                radius: 32.0,
                padding: const EdgeInsets.all(10.0),
                backgroundColor: HexColor("#aec2e6"),
                foregroundColor: HexColor("#DBE2EF"),
                borderColor: Colors.white,
                borderWidth: 2,
                innerVerticalPadding: 14,
                children: [
                  ButtonBarEntry(
                    onTap: () {
                      setState(() {
                        gender = 'woman';
                        category = '';
                      });
                      print('woman tapped');
                    },
                    child: Text("woman",style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ButtonBarEntry(
                    onTap: () {
                      setState(() {
                        gender = 'man';
                        category = '';
                        _selectedCategory = null;
                      });
                      print('man tapped');
                    },
                    child: Text("man", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              AnimatedButtonBar(
                radius: 32.0,
                padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,20.0),
                backgroundColor: HexColor("#aec2e6"),
                foregroundColor: HexColor("#DBE2EF"),
                borderWidth: 2,
                innerVerticalPadding: 14,
                borderColor: Colors.white,
                children: gender == 'woman' ? [
                  ButtonBarEntry(
                    onTap: () {
                      setState(() {
                        category = 'upper';
                        _selectedCategory = 'upper';
                      });
                      print('upper tapped');
                    },
                    child: Text('upper'),
                  ),
                  ButtonBarEntry(
                    onTap: () {
                      setState(() {
                        category = 'lower';
                        _selectedCategory = 'lower';
                      });
                      print('lower tapped');
                    },
                    child: Text('lower'),
                  ),
                  ButtonBarEntry(
                    onTap: () {
                      setState(() {
                        category = 'dress';
                        _selectedCategory = 'dress';
                      });
                      print('dress tapped');
                    },
                    child: Text('dress'),
                  ),
                ] : gender == 'man' ? [
                  ButtonBarEntry(
                    onTap: () {
                      setState(() {
                        category = 'upper';
                        _selectedCategory = 'upper';
                      });
                      print('upper tapped');
                    },
                    child: Text('upper'),
                  ),
                  ButtonBarEntry(
                    onTap: () {
                      setState(() {
                        category = 'lower';
                        _selectedCategory = 'lower';
                      });
                      print('lower tapped');
                    },
                    child: Text('lower'),
                  ),
                ] : [],
              ),
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
            height: 200,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (person != null && cloth != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenerateImageCard(gender: gender, category: category, personImageName: person, clothImageName: cloth),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please insert both person and cloth images.'),
                            ),
                          );
                        }
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
                  ],
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
      imageQuality: 70,
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
        ),
      ],
    );
  }
}
