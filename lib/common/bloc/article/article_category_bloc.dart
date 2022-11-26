import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/article_service.dart';
import 'package:mobile_frontend/common/services/firebase/wane_fire_storage.dart';
import 'package:mobile_frontend/constraints.dart';

class ArticleCategoryBloc implements Bloc {


  final _controller = StreamController< List<Item>? >.broadcast();
  Sink  < List<Item>? > get sink   => _controller.sink;
  Stream< List<Item>? > get stream => _controller.stream;
  

  Future<void> findLatestItemsByCategoryId(int categoryId, int limit) async {
    sink.add(null);

    try {

      List<Item> items = (await ArticleService.findItemsByCategory(categoryId, limit))!;
      sink.add(items);

    } on WaneBackException catch(e) {
      var error = e.message;
      // print("error: ${error}");
    } catch (e, stacktrace) {
      // inspect(e);
      // var error = "Erreur interne. Veuillez nous excuser";
    }

  }


  @override
  void dispose() {
    // TODO: implement dispose
    _controller.close();
  }
  
}