import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final String loggedUserId = FirebaseAuth.instance.currentUser!.uid;

class SessionManager {
  Future<String> getUsername() async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(loggedUserId)
        .get();

    return userData.data()!['username'];
  }
}
