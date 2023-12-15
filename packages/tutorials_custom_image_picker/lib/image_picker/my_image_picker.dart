import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../photo_manager/controller/home_controller.dart';

class MyImagePicker {
  Future<void> pickImage(ImageSource source) async {
    // ImagePicker 인스턴스 생성
    ImagePicker imagePicker = ImagePicker();
    try {
      // 촬영 또는 앨범에서 가져온 이미지를 변수에 저장
      XFile? pickedImage = await imagePicker.pickImage(source: source);
      // 선택된 이미지가 없다면 함수 종료
      if (pickedImage == null) return;
      // 이미지 비율 맞춰 자름
      File? croppedImage = await _cropImage(imageFile: File(pickedImage.path));
      if (croppedImage == null) return;
      // 사용자가 프로필 이미지를 변경했는지 안했는지를 확인
      Get.put(HomeController()).hasSelectedPhoto.value = true;
      // 작업이 끝난 이미지를 전역 변수에 담음 (변경된 프로필 이미지를 바로 적용하기 위함)
      Get.put(HomeController()).selectedFile.value = croppedImage;
    } catch (err) {
      debugPrint("_pickImage 사용 중 에러 발생 : $err");
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

}