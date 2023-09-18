import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String get loggedUserId => FirebaseAuth.instance.currentUser!.uid;

Future<String> getUsername(String userId) async {
  final userData =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  return userData.data()!['username'];
}

const String defaultUserImageUrl = 'https://img.freepik.com/vecteurs-libre/illustration-icone-vecteur-dessin-anime-volant-abeille-mignonne-concept-icone-nature-animale-isole-vecteur-premium_138676-6016.jpg?w=2000';

// Future<void> deleteUser(String uderId) async {
//   FirebaseAuth.instance.currentUser!.delete();
// }
