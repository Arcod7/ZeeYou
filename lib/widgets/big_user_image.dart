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
    return Scaffold(
      appBar: AppBar(title: const Text('WSH GROS')),
      body: Hero(
          tag: imageUrl,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.none,
            repeat: ImageRepeat.repeat,
          )),
    );
  }
}
