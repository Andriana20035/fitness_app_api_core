import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String source;
  final BoxFit fit;
  final double? width;
  final double? height;

  const AppImage({
    super.key,
    required this.source,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (source.startsWith('assets/')) {
      return Image.asset(
        source,
        width: width,
        height: height,
        fit: fit,
      );
    }

    return Image.network(
      source,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade300,
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_not_supported,
          ),
        );
      },
    );
  }
}