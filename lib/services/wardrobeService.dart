import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WardrobeService {
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
      CollectionReference categoryCollection = FirebaseFirestore.instance.collection('Users').doc(userId).collection(category);
      QuerySnapshot categorySnapshot = await categoryCollection.get();

      if (categorySnapshot.docs.isNotEmpty) {
        String documentId = categorySnapshot.docs.first.id;
        List<String> existingImageUrls = [];
        var existingData = categorySnapshot.docs.first.data();
        if (existingData != null && existingData is Map<String, dynamic> && existingData.containsKey('imageUrls')) {
          existingImageUrls = List<String>.from(existingData['imageUrls']);
        }
        existingImageUrls.add(imageUrl);
        await categoryCollection.doc(documentId).set({'imageUrls': existingImageUrls});
      } else {
        await categoryCollection.add({'imageUrls': [imageUrl]});
      }
      print('Image URL saved to database successfully');
    } catch (e) {
      print('Error saving image URL to database: $e');
    }
  }

  Future<List<String>> getImageUrlsByCategory(String userId, String category) async {
    try {
      CollectionReference categoryCollection = FirebaseFirestore.instance.collection('Users').doc(userId).collection(category);
      QuerySnapshot querySnapshot = await categoryCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        if (documentSnapshot.exists) {
          Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
          if (data != null && data.containsKey('imageUrls')) {
            List<dynamic> imageUrlsDynamic = data['imageUrls'];
            List<String> imageUrls = List<String>.from(imageUrlsDynamic);
            return imageUrls;
          } else {
            print('Image URLs not found for the specified category');
            return [];
          }
        } else {
          print('Document does not exist for the specified category');
          return [];
        }
      } else {
        print('No documents found in the specified category');
        return [];
      }
    } catch (e) {
      print('Error retrieving image URLs: $e');
      return [];
    }
  }

  Future<void> deleteImageUrlFromDatabase(String userId, String category, String imageUrl) async {
    try {
      CollectionReference categoryCollection = FirebaseFirestore.instance.collection('Users').doc(userId).collection(category);
      QuerySnapshot querySnapshot = await categoryCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        if (documentSnapshot.exists) {
          List<String> existingImageUrls = [];
          var existingData = documentSnapshot.data();
          if (existingData != null && existingData is Map<String, dynamic> && existingData.containsKey('imageUrls')) {
            existingImageUrls = List<String>.from(existingData['imageUrls']);
          }
          existingImageUrls.remove(imageUrl);
          await categoryCollection.doc(documentSnapshot.id).set({'imageUrls': existingImageUrls});
          print('Image URL deleted from database successfully');
        } else {
          print('Document does not exist for the specified category');
        }
      } else {
        print('No documents found in the specified category');
      }
    } catch (e) {
      print('Error deleting image URL from database: $e');
    }
  }
}
