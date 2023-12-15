import 'dart:io';

import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoPickController extends GetxController {
  RxBool isLoading = false.obs;
  // 사용자의 모든 앨범을 담는 변수
  var albums = <AssetPathEntity>[].obs;
  // 사용자가 현재 선택한 앨범을 담을 변수
  var currentAlbum = Rxn<AssetPathEntity>();
  // 앨범별 사진 개수를 담는 변수
  var assetCounts = <int>[].obs;
  // 선택한 앨범의 모든 사진을 담는 변수
  var assets = <AssetEntity>[].obs;
  // 선택된 사진을 담는 변수
  var selectedAsset = Rxn<AssetEntity>();

  @override
  void onInit() {
    takePhoto();
    super.onInit();
  }

  Future<List<AssetPathEntity>> requestAlbums(RequestType type) async {
    final List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(type: type);

    return albums;
  }

  Future<List<AssetEntity>> requestAlbumAssets(AssetPathEntity album) async {
    final List<AssetEntity> assets = await album.getAssetListRange(
      start: 0,
      end: 10000000000,
    );

    return assets;
  }

  Future<File?> cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void takePhoto() async {
    isLoading.value = true;

    // 사용자 스토리지 접근에 관한 권한을 확인
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth == false) {
      // 권한이 거절된 경우
      Get.back();
      return;
    }
    // 기기에 존재하는 모든 앨범을 가져옴
    albums.value = await requestAlbums(RequestType.image);
    // 앨범별 사진의 개수를 저장
    for (final album in albums) {
      assetCounts.add(await album.assetCountAsync);
    }
    // 첫번째 앨범을 선택된 앨범으로 담음
    currentAlbum.value = albums.first;
    // 선택된 앨범의 모든 사진을 가져옴
    assets.value = await requestAlbumAssets(currentAlbum.value!);

    if (assets.isNotEmpty) {
      isLoading.value = false;
    }
  }
}
