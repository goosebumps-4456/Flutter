import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoDetailScreen extends StatelessWidget {
  final File imageFile;

  const PhotoDetailScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이미지 상세 보기 페이지'),
      ),
      body: PhotoView(
        imageProvider: FileImage(imageFile),
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 2,
        enableRotation: true,
      ),
    );
  }
}
