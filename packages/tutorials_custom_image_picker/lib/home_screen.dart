import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutorials_custom_image_picker/image_picker/my_image_picker.dart';
import 'package:tutorials_custom_image_picker/photo_manager/controller/home_controller.dart';
import 'package:tutorials_custom_image_picker/photo_manager/photo_detail_screen.dart';

import 'photo_manager/photo_pick_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Obx(
            () => homeController.usePhotoManager.value
                ? const Text("Photo Manager")
                : const Text("Image Picker"),
          ),
        ),
        body: Obx(
          () => Center(
            child: homeController.hasSelectedPhoto.value
                ? GestureDetector(
                    onTap: () {
                      Get.to(() => PhotoDetailScreen(
                          imageFile:
                              File(homeController.selectedFile.value!.path)));
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey,
                      child: Image.file(
                        File(homeController.selectedFile.value!.path),
                      ),
                    ),
                  )
                : Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey,
                    child: const Center(child: Text("선택된 파일 없음")),
                  ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "library_change_button",
              onPressed: () {
                homeController.usePhotoManager.value = !homeController.usePhotoManager.value;
              },
              child: const Icon(Icons.change_circle_outlined, size: 40),
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              heroTag: "move_to_photo_screen_button",
              onPressed: () {
                if (homeController.usePhotoManager.value) {
                  // "Photo manager"를 사용하는 경우
                  Get.to(() => PhotoPickScreen());
                } else {
                  // "Image picker"를 사용하는 경우
                  MyImagePicker().pickImage(ImageSource.gallery);
                }
              },
              child: const Icon(Icons.photo, size: 35),
            ),
          ],
        ),
      ),
    );
  }
}
