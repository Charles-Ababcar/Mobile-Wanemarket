import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/item_photo_info.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/article_service.dart';
import 'package:mobile_frontend/common/services/firebase/wane_fire_storage.dart';
import 'package:mobile_frontend/constraints.dart';

class ArticleBloc implements Bloc {

  final _loginErrorController = StreamController<String?>.broadcast();
  Sink<String?>   get loginErrorSink   => _loginErrorController.sink;
  Stream<String?> get loginErrorStream => _loginErrorController.stream;
  
  final _loadingController = StreamController<bool?>.broadcast();
  Sink  <bool?> get loadingSink   => _loadingController.sink;
  Stream<bool?> get loadingStream => _loadingController.stream;

  // stream loginError
  final _successRequest = StreamController<bool?>.broadcast();
  Sink<bool?>   get successRequestSink   => _successRequest.sink;
  Stream<bool?> get successRequestStream => _successRequest.stream;

  bool isProcessing = false;
  Future<bool> canPopPage() => Future.value (isProcessing == true ? false: true);//(blocScreen == true);

  Future<void> submit(int? marketplaceId, Item item, List<ItemPhotoInfo> images) async {
    loginErrorSink.add(null);
    loadingSink.add(true);
    this.isProcessing = true;

    try {

      ///
      /// END ARTICLE REQUEST
      ///
      int articleId = await ArticleService.sendArticleRequest(marketplaceId, item);

      /**
       * handle photo
       * delete which needed to be deleted
       * add what have to be added
       */
      await this.handlePictures(articleId, images);

      loadingSink.add(false);
      successRequestSink.add(true);
      this.isProcessing = false;

      /**
       * update articles
       */
      await this.loadOwnerArticles();

    } on WaneBackException catch(e) {
      loginErrorSink.add(e.message);
      loadingSink.add(false);
      this.isProcessing = false;
    } catch (e, stacktrace) {
      inspect(e);
      loginErrorSink.add(INTERNAL_ERROR_MESSAGE);
      loadingSink.add(false);
      this.isProcessing = false;
    }

  }

  Future<void> handlePictures(int itemId, List<ItemPhotoInfo> itemPhotoInfos) async {

    ///////////////////////////////////
    /// IMPORT IMAGES TO FIRESTORE/////
    ///////////////////////////////////

    List<ItemPhotoInfo> pituresToUpload = itemPhotoInfos.where( (image) =>  image.isNew! && !image.isDeleted! ).toList();

    // upload all images and get urls
    List<String> urls = await FirebaseImageStorage.uploadImages(pituresToUpload);

    for(String url in urls) {
      await ArticleService.sendImagesForArticle(itemId, url);
      print("-------------- one image created and referenced");
    }

  }

  ///////////////////////////////////
  ///   IMPORT owner artilrd    /////
  ///////////////////////////////////

  ////loading error 
  final _itemsErrorController = StreamController<String?>.broadcast();
  Sink<String?>   get itemsErrorSink   => _itemsErrorController.sink;
  Stream<String?> get itemsErrorStream => _itemsErrorController.stream;
  

  // owner articles
  final _ownerArticles = StreamController<List<Item>?>.broadcast();
  Sink<List<Item>?>   get ownerArticlesSink   => _ownerArticles.sink;
  Stream<List<Item>?> get ownerArticlesStream => _ownerArticles.stream;

  Future<void> loadOwnerArticles() async {
    try {
      
      List<Item>? items = await ArticleService.loadOwnerItems();
      ownerArticlesSink.add(items);

    } on WaneBackException catch(e) {
      itemsErrorSink.add(e.message);
      loadingSink.add(false);
    } catch (e, stacktrace) {
      itemsErrorSink.add(INTERNAL_ERROR_MESSAGE);
      loadingSink.add(false);
    }
  }

  ///////////////////////////////////
  ///   DELETE owner artilrd    /////
  ///////////////////////////////////

  Future <bool> deleteArticle (int id) async {   
    try {
      
      bool isDeleted = await ArticleService.deleteItem(id);
      await this.loadOwnerArticles();
      // ownerArticlesSink.add(items);
      return isDeleted;
    } on WaneBackException catch(e) {
      itemsErrorSink.add(e.message);
      loadingSink.add(false);
      return false;
    } catch (e, stacktrace) {
      itemsErrorSink.add(INTERNAL_ERROR_MESSAGE);   
      loadingSink.add(false);
      inspect(e);
      return false;
    }
  }

  ///////////////////////////////////
  ///    DELETE owner artilrd   /////
  ///////////////////////////////////

  Future<bool> changeVisibility (int itemId, bool visibility)  async {   
    try {
      await ArticleService.changeVisibility(itemId, visibility);
      return true;
    } on WaneBackException catch(e) {
      return false;
    } catch (e, stacktrace) {
      inspect(e);
      inspect(stacktrace);
      return false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _loadingController.close();
    _loginErrorController.close();
    _successRequest.close();
    // _ownerArticles.close();
    _itemsErrorController.close();
  }

  // singleton
  static final ArticleBloc _instance = ArticleBloc._internal();
  factory ArticleBloc () => _instance;
  ArticleBloc._internal();

}

ArticleBloc ownerItemsBloc = ArticleBloc();