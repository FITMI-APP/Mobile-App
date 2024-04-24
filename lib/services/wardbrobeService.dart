import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> uploadImage(File imageFile, String userId, String category) async {
  try {
    String fileName = '$category/${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask.whenComplete(() => null);
    String imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}

Future<void> saveImageUrlToDatabase(String userId, String category, String imageUrl) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).collection(category).add({
      'imageUrl': imageUrl,
    });
    print('Image URL saved to database successfully');
  } catch (e) {
    print('Error saving image URL to database: $e');
  }
}
