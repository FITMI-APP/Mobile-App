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
    // Get the reference to the subcollection based on the category
    CollectionReference categoryCollection = FirebaseFirestore.instance.collection('Users').doc(userId).collection(category);

    // Check if the category subcollection exists
    QuerySnapshot categorySnapshot = await categoryCollection.get();

    if (categorySnapshot.docs.isNotEmpty) {
      // Get the first (and only) document in the subcollection
      String documentId = categorySnapshot.docs.first.id;

      // Fetch existing image URLs if any
      List<String> existingImageUrls = [];
      var existingData = categorySnapshot.docs.first.data();
      if (existingData != null && existingData is Map<String, dynamic> && existingData.containsKey('imageUrls')) {
        existingImageUrls = List<String>.from(existingData['imageUrls']);
      }

      // Add the new image URL to the existing list
      existingImageUrls.add(imageUrl);

      // Update the document with the merged list of image URLs
      await categoryCollection.doc(documentId).set({
        'imageUrls': existingImageUrls,
      });
    } else {
      // If the subcollection doesn't exist, create a new document and add the image URL
      await categoryCollection.add({
        'imageUrls': [imageUrl], // Create a list with the new URL
      });
    }

    print('Image URL saved to database successfully');
  } catch (e) {
    print('Error saving image URL to database: $e');
  }
}


