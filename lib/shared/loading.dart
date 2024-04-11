import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor("#DBE2EF"),
      child: Center(
        child: SpinKitThreeBounce(
          color: HexColor("#3F72AF"),
          size: 50,

        ),
      ),
    );
  }
}
