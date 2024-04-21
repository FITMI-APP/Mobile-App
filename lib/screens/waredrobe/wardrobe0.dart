import 'package:flutter/material.dart';
import '../../shared/Header.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../widget/navigation_drawer_widget.dart';

// class wardrobe extends StatefulWidget {
//
//   const wardrobe({Key? key}) : super(key: key);
//
//   @override
//   State<wardrobe> createState() => _wardrobe();
// }
// class _wardrobe extends State<_wardrobe> {
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: HexColor("#3F72AF"),
//       drawer: NavigationDrawerWidget(),
//       appBar: Header(),
//
// }

class clothItems extends StatelessWidget {
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