import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tutorials_custom_image_picker/photo_manager/controller/home_controller.dart';
import 'package:tutorials_custom_image_picker/photo_manager/controller/photo_pick_controller.dart';

class PhotoPickScreen extends StatelessWidget {
  PhotoPickScreen({Key? key}) : super(key: key);

  final PhotoPickController controller = Get.put(PhotoPickController());

  void _openAlbumList(context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: Get.height * 0.5,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: controller.albums.length,
              itemBuilder: (context, index) {
                final album = controller.albums[index];
                final photoCount = controller.assetCounts[index];
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: ListTile(
                    onTap: () async {
                      controller.currentAlbum.value = album;
                      if (controller.currentAlbum.value != null) {
                        controller.assets.value = await controller
                            .requestAlbumAssets(controller.currentAlbum.value!);
                      }
                      Get.back();
                    },
                    leading: Text("${album.name} ( $photoCount )"),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: GestureDetector(
            onTap: () {
              _openAlbumList(context);
            },
            child: Row(
              children: [
                Obx(
                  () => controller.currentAlbum.value == null
                      ? const Text("")
                      : Text(controller.currentAlbum.value!.name),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            )),
      ),
      body: Obx(
        () => Column(
          children: [
            if (controller.isLoading.value == true)
              const Flexible(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            if (controller.assets.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: controller.assets.length,
                  itemBuilder: (context, index) {
                    final entity = controller.assets[index];
                    return GestureDetector(
                      onTap: () async {
                        controller.selectedAsset.value = entity;
                        final file = await controller.selectedAsset.value?.file;
                        if (file == null) return;
                        final croppedFile = await ImageCropper().cropImage(
                          sourcePath: file.path,
                          aspectRatio:
                              const CropAspectRatio(ratioX: 1, ratioY: 1),
                        );
                        if (croppedFile == null) return;
                        Get.put(HomeController()).hasSelectedPhoto.value = true;
                        Get.put(HomeController()).selectedFile.value =
                            File(croppedFile.path);
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: assetPhotoWidget(entity),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget assetPhotoWidget(entity) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: AssetEntityImage(
        entity, // 표시할 객체
        isOriginal: false, // 사진의 원본 크기를 로드할 것인가
        thumbnailSize: const ThumbnailSize.square(250), // 이미지 크기
        fit: BoxFit.cover, // 이미지를 가능한 크게 확대하여 영역을 채움
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.error,
              color: Colors.black38,
            ),
          );
        },
      ),
    );
  }
}
