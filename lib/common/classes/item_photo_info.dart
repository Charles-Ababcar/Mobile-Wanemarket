import 'dart:io';

class ItemPhotoInfo {

  /**
   * id
   */
  int? id;

  /**
   * name
   */
  String? name;

  /**
   * url of picture (remote or local)
   */
  String? url;

  /**
   * isNew = true means photo
   * has been added by user while editing item
   * isNew = false means photo existed before editing
   */
  bool? isNew;

  /**
   * isDeleted = true meand photo has been deleted
   * by user while editing item
   * isDeleteed = false means photos has not been touched
   * by user why editing
   */
  bool? isDeleted;

  /**
   * If new photo is set
   * thaan
   */
  File? file;

}