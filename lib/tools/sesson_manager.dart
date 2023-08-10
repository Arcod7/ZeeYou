import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final String loggedUserId = FirebaseAuth.instance.currentUser!.uid;

Future<String> getUsername(String userId) async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    return userData.data()!['username'];
  }
