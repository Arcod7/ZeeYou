import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
      String downloadedUrl = await FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('$loggedUserId.jpg')
          .getDownloadURL();
      prefs.setString('currentUserImageUrl', downloadedUrl);
      return downloadedUrl;
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => BigUserImage(imageUrl: data.data!)));
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
