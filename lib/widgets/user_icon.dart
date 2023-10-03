import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeeyou/tools/user_manager.dart';
import 'package:zeeyou/widgets/big_user_image.dart';

class UserIcon extends StatelessWidget {
  const UserIcon({super.key});

  Future<String> getUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? urlInStorage = prefs.getString('currentUserImageUrl');
    if (urlInStorage != null) {
      return urlInStorage;
    } else {
      final user = await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedUserId)
          .get();
      String downloadUrl = user.data()!['image_url'];
      prefs.setString('currentUserImageUrl', downloadUrl);
      return downloadUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: null,
      future: getUrl(),
      builder: (ctx, data) => GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: data.data == null
              ? const CircularProgressIndicator()
              : GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (_, __, ___) =>
                            (BigUserImage(imageUrl: data.data!))));
                  },
                  child: Hero(
                      tag: data.data!,
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(data.data!),
                      )),
                ),
        ),
      ),
    );
  }
}
