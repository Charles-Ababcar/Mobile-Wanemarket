

import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/common/bloc/article/article_bloc.dart';
import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/article_service.dart';
import 'package:mobile_frontend/constraints.dart';

class ArticleDescriptionBloc implements Bloc {

  final _requestErrorController = StreamController<String?>.broadcast();
  Sink<String?>   get loginErrorSink   => _requestErrorController.sink;
  Stream<String?> get loginErrorStream => _requestErrorController.stream;

  final _loadingController = StreamController<bool?>.broadcast();
  Sink  <bool?> get loadingSink   => _loadingController.sink;
  Stream<bool?> get loadingStream => _loadingController.stream;

  final _itemController = StreamController<Item>.broadcast();
  Sink   <Item?> get itemSink   => _itemController.sink;
  Stream <Item?> get itemStream => _itemController.stream;

  Future<void> loadItem(int? itemId, bool isAdmin) async {

    try {

      Item? item;
      print("AArticleBloc.loadItem() ${isAdmin}");
      if(isAdmin) {
        print(" - loadOneItemAdmin");
        item = await ArticleService.loadOneItemAdmin(itemId);
      } else {
        print(" - loadOneItem");
        item = await ArticleService.loadOneItem(itemId);
      }

      itemSink.add(item);

      if (item == null) {
        throw new WaneBackException("Annonce non trouvée");
      }

    }
    on WaneBackException catch(e) {
      inspect(e);
      var error = e.message;
      loginErrorSink.add(error);
      loadingSink.add(false);
    } catch (e, stacktrace) {
      loginErrorSink.add(INTERNAL_ERROR_MESSAGE);
      loadingSink.add(false);
      inspect(e);
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _requestErrorController.close();
    _itemController.close();
    _loadingController.close();
  }

}