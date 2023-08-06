import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserIcon extends StatefulWidget {
  const UserIcon({super.key});

  @override
  State<UserIcon> createState() => _UserIconState();
}

class _UserIconState extends State<UserIcon> {
  String? url;

  @override
  void initState() {
    super.initState();
    getUserIcon();
  }

  void getUserIcon() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userIconUrl = await FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('$uid.jpg')
        .getDownloadURL();
    setState(() {
      url = userIconUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: url == null
            ? const CircularProgressIndicator()
            : CircleAvatar(
                backgroundImage: NetworkImage(url!),
              ),
      ),
    );
  }
}
