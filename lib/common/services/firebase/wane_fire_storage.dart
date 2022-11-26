import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobile_frontend/common/classes/item_photo_info.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';

class FirebaseImageStorage {

  static const String ANNONCE_IMAGES_URL = "annonce_images/";
  
    /**
   * upload image to firebase
   * return donload url
   */
  static Future<List<String>> uploadImages(List<ItemPhotoInfo> itemPhotoInfos) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      List<String> urls = [];

      for(ItemPhotoInfo itemPhotoInfo in itemPhotoInfos) {
        Reference ref = storage.ref().child(ANNONCE_IMAGES_URL + itemPhotoInfo.name!);
        await ref.putFile(itemPhotoInfo.file!);
        String url = await ref.getDownloadURL();

        if(url == null) {
          throw new WaneBackException("Erreur téléchargement des images");
        }
        urls.add(url);
      }

      return urls;
    } catch (e, stacktrace) {
      throw new WaneBackException("Erreur dans le téléchargement des images");
    }
  }

  /**
   * upload image to firebase
   * return donload url
   */
  static Future<void> deleteFile(List <ItemPhotoInfo> itemPhotoInfos) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;

      for(ItemPhotoInfo itemPhotoInfo in itemPhotoInfos) {
        Reference ref = storage.refFromURL(itemPhotoInfo.url!);
        await ref.delete();
      }

    } catch (e, stacktrace) {
      print("------------------ ${e}");
      print(stacktrace);
      throw new WaneBackException("Erreur dans la suppression des images");
    }
  }

}