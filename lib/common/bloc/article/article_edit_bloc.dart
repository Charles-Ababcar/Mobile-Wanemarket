import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/common/bloc/article/article_bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/item_photo_info.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/article_service.dart';
import 'package:mobile_frontend/common/services/firebase/wane_fire_storage.dart';
import 'package:mobile_frontend/constraints.dart';

import '../bloc.dart';

class ArticleEditBloc implements Bloc {

  final _errorController = StreamController<String?>.broadcast();
  Sink<String?>   get errorSink   => _errorController.sink;
  Stream<String?> get errorStream => _errorController.stream;

  final _loadingController = StreamController<bool?>.broadcast();
  Sink  <bool?> get loadingSink   => _loadingController.sink;
  Stream<bool?> get loadingStream => _loadingController.stream;

  // stream loginError
  final _successRequest = StreamController<bool?>.broadcast();
  Sink<bool?>   get successRequestSink   => _successRequest.sink;
  Stream<bool?> get successRequestStream => _successRequest.stream;

  bool isProcessing = false;
  Future<bool> canPopPage() => Future.value (isProcessing == true ? false: true);

  Future<void> update(Item item, List<ItemPhotoInfo> itemPhotoInfos) async {
    errorSink.add(null);
    loadingSink.add(true);
    this.isProcessing = true;

    try {

      ///
      /// update item
      ///
      await ArticleService.updateItem(item);

      ///
      ///  update photos
      ///
      print("------ SUPPRESSION DES IMAGES ------");
      await this.handlePictures(item.id!, itemPhotoInfos);

      ///
      /// reload items
      ///
      await ownerItemsBloc.loadOwnerArticles();

      loadingSink.add(false);
      successRequestSink.add(true);
      this.isProcessing = false;

    } on WaneBackException catch(e) {
      errorSink.add(e.message);
      loadingSink.add(false);
      this.isProcessing = false;
    } catch(e, stacktrace) {
      inspect(e);
      errorSink.add(INTERNAL_ERROR_MESSAGE);
      loadingSink.add(false);
      this.isProcessing = false;
    }
  }

  Future<void> handlePictures(int itemId, List<ItemPhotoInfo> itemPhotoInfos) async {

    ///////////////////////////////////////
    /// DELETE IMAGES FROM FIRESTORE //////
    ///////////////////////////////////////

    List<ItemPhotoInfo> pituresToDelete = itemPhotoInfos.where( (image) => image.isDeleted! && !image.isNew!).toList();
    print(" --------- IMAGE A SUPPRIMER ${pituresToDelete.length}");

    // delete from app
    for(ItemPhotoInfo itemPhotoInfo in pituresToDelete) {
      await ArticleService.deleteImageFromArticle(itemId, itemPhotoInfo);
      print("-------------- image ${itemPhotoInfo.name} deleted");
    }

    // delete images from firebase
    await FirebaseImageStorage.deleteFile(pituresToDelete);

    ///////////////////////////////////
    /// IMPORT IMAGES TO FIRESTORE/////
    ///////////////////////////////////

    List<ItemPhotoInfo> pituresToUpload = itemPhotoInfos.where( (image) =>  image.isNew! && !image.isDeleted! ).toList();
    print(" --------- IMAGE A AJOUTER  ${pituresToUpload.length}");

    // upload all images and get urls
    List<String> urls = await FirebaseImageStorage.uploadImages(pituresToUpload);

    for(String url in urls) {
      await ArticleService.sendImagesForArticle(itemId, url);
      print("-------------- one image created and referenced");
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _errorController.close();
    _loadingController.close();
    _successRequest.close();
  }


  // singleton
  static final ArticleEditBloc _instance = ArticleEditBloc._internal();
  factory ArticleEditBloc () => _instance;
  ArticleEditBloc._internal();

}

ArticleEditBloc articleEditBloc = ArticleEditBloc();