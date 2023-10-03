import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BigUserImage extends StatelessWidget {
  const BigUserImage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: const EdgeInsets.all(15),
        color: const Color.fromARGB(160, 255, 255, 255),
        child: Hero(
            tag: imageUrl,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.contain),
                ),
              ),
            )),
      ),
    );
  }
}
