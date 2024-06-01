// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:grad/services/authenticate.dart';
// import '../../shared/constants.dart';
// import 'package:hexcolor/hexcolor.dart';
//
// final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
// class Header extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//
//   const Header({Key? key, required this.title}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final AuthService _auth = AuthService();
//
//     return AppBar(
//      // backgroundColor: Colors.white,
//
//       bottom: PreferredSize(
//         preferredSize: Size.fromHeight(56), // Adjust the height as needed
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 HexColor("#3f1a8d"),
//                 HexColor("#4e24ae"),
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: AppBar(
//             backgroundColor: Colors.transparent, // Make the inner AppBar transparent
//             elevation: 0,
//             // Set elevation to 0 to avoid double shadow
//             title: Row(
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: Colors.white, // Set text color to white
//                     fontSize: 18.0, // Adjust font size if needed
//                     fontWeight: FontWeight.bold, // Adjust font weight if needed
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }
import 'package:flutter/material.dart';
import 'package:grad/services/authenticate.dart';
import 'package:hexcolor/hexcolor.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const Header({Key? key, required this.title, this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return AppBar(
      backgroundColor: Colors.white,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              HexColor("#3f1a8d"),
              HexColor("#4e24ae"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      elevation: 0, // Set elevation to 0 to avoid double shadow
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.white), // Set the icon color to white
        onPressed: () {
          scaffoldKey?.currentState?.openDrawer();
        },
      ),
      title: Text(title, style: TextStyle(color: Colors.white)), // Ensure title text is white
    );

  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}