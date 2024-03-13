import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseSer{

  final String uid;

  DatabaseSer({required this.uid});

  final CollectionReference fluttoraColl = FirebaseFirestore.instance.collection('fluttora');

  Future update(String sugars, String name, int strength) async {
    return fluttoraColl.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength
    });
  }
}