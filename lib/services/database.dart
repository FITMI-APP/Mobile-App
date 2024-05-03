import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad/models/user.dart';
class Database {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final CollectionReference<MyUser> _users;
  Database() {
    _users = _db.collection('Users').withConverter<MyUser>(
      fromFirestore: (snapshots, _) => MyUser.fromJson(snapshots.data()!),
      toFirestore: (user, _) => user.toJson(),
    );
  }
  Stream<QuerySnapshot<MyUser>> getUsers() {
    return _users.snapshots();
  }

  // Future<void> addUser(MyUser user) async {
  //   await _users.doc(user.uid).set(user);
  //
  // }
  Future<void> addUser(MyUser user) async {
    try {
      // await _users.doc(user.uid).set(user); // Assuming MyUser has a toMap() method to convert it to a Map
      // await _createUserCollections(user.uid);
      await _users.doc(user.uid).set(user).then((_) async {
        await _createUserCollections(user.uid,user.gender);
      });
    } catch (e) {
      // Handle errors
      print("Error adding user: $e");
    }
  }

  // Future<void> _createUserCollections(String? userId) async {
  //   try {
  //     final userRef = _users.doc(userId);
  //
  //     // Create the "upper" subcollection
  //     await userRef.collection('Upper').add({});
  //
  //     // Create the "lower" subcollection
  //     await userRef.collection('Lower').add({});
  //
  //     // Create the "dress" subcollection
  //     await userRef.collection('Dresses').add({});
  //   } catch (e) {
  //     // Handle errors
  //     print("Error creating user collections: $e");
  //     rethrow; // Rethrow the exception to propagate it further if needed
  //   }
  // }
  Future<void> _createUserCollections(String? userId, String gender) async {
    try {
      final userRef = _users.doc(userId);
      await userRef.collection('Upper').add({});
      await userRef.collection('Lower').add({});
      if (gender.toLowerCase() == 'female') {
        await userRef.collection('Dresses').add({});
      }
    } catch (e) {
      // Handle errors
      print("Error creating user collections: $e");
      rethrow; // Rethrow the exception to propagate it further if needed
    }
  }

}

// Future<MyUser?> getUserById(String userId) async {
//   try {
//     final userDoc = await _users.doc(userId).get();
//     if (userDoc.exists) {
//       return userDoc.data();
//     } else {
//       print('User document does not exist in Firestore');
//       return null;
//     }
//   } catch (e) {
//     // Handle any errors that occur during the retrieval process
//     print('Error retrieving user info: $e');
//     return null;
//   }
// }
// }