import 'dart:io';
import 'package:get/get.dart';

class HomeController extends GetConnect{
  RxBool hasSelectedPhoto = false.obs;
  Rx<File?> selectedFile = Rx<File?>(null);
  RxBool usePhotoManager = true.obs;
}