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

  Future<void> addUser(MyUser user) async {
    await _users.doc(user.uid).set(user);
  }

  Future<MyUser?> getUserById(String userId) async {
    try {
      final userDoc = await _users.doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data();
      } else {
        print('User document does not exist in Firestore');
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the retrieval process
      print('Error retrieving user info: $e');
      return null;
    }
  }
}