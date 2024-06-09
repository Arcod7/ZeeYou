import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class BigUserImage extends StatefulWidget {
  const BigUserImage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  State<BigUserImage> createState() => _BigUserImageState();
}

class _BigUserImageState extends State<BigUserImage> {
  bool isImageCircle = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        // child: Container(
        //   padding: isImageCircle
        //       ? const EdgeInsets.all(15)
        //       : const EdgeInsets.symmetric(horizontal: 15, vertical: 200),
        //   color: const Color.fromARGB(10, 255, 255, 255),
          child: Hero(
            tag: widget.imageUrl,
            // child: GestureDetector(
            //   onTap: () {
            //     setState(() => isImageCircle = !isImageCircle);
            //   },
              child: PhotoView(
                
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                imageProvider: CachedNetworkImageProvider(widget.imageUrl),
              ),
              // CachedNetworkImage(
              //   imageUrl: widget.imageUrl,
              //   imageBuilder: (context, imageProvider) => Container(
              //     decoration: BoxDecoration(
              //       shape:
              //           isImageCircle ? BoxShape.circle : BoxShape.rectangle,
              //       borderRadius:
              //           isImageCircle ? null : BorderRadius.circular(30),
              //       image: DecorationImage(
              //           image: imageProvider,
              //           fit: isImageCircle ? BoxFit.contain : BoxFit.cover),
              //     ),
              //   ),
              // ),
            // ),
          // ),
        ),
      ),
    );
  }
}
