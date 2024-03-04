import 'package:flutter/material.dart';

final textInputDecoration = InputDecoration(
  hintText: '12%fTks,l',
  fillColor: Colors.white54,
  filled: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(color: Colors.deepPurple, width: 50)
  ),
);

final logo = Padding(
  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
  child: Builder(
      builder: (BuildContext context) {
        return Image.asset(
            'assets/logoo.png',
            fit: BoxFit.contain
        );
      }
  ),
);

final button = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.deepPurple[100]),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
);
