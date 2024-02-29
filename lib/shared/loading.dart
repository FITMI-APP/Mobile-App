import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[200],
      child: Center(
        child: SpinKitThreeBounce(
          color: Colors.deepPurple.shade100,
          size: 50,

        ),
      ),
    );
  }
}
