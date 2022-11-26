import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/purchase_order.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/article_service.dart';
import 'package:mobile_frontend/common/services/purchase_order_service.dart';
import 'package:mobile_frontend/constraints.dart';

class WishListBloc extends Bloc {


  final _requestErrorController = StreamController<String?>.broadcast();
  Sink<String?>   get loginErrorSink   => _requestErrorController.sink;
  Stream<String?> get loginErrorStream => _requestErrorController.stream;
  
  final _lekketController = StreamController< List<Item>? >.broadcast();
  Sink   < List<Item>? > get wishListSink   => _lekketController.sink;
  Stream < List<Item>? > get wishListStream => _lekketController.stream;

  Future<void> loadWishList() async {
    wishListSink.add(null);
    try {

      List<Item>? list = (await ArticleService.loadWishList())!;

      inspect(list);
      wishListSink.add(list);

      } on WaneBackException catch(e) {
      var error = e.message;
      loginErrorSink.add(error);
    } catch (e, stacktrace) {
      loginErrorSink.add(INTERNAL_ERROR_MESSAGE);   
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _lekketController.close();
    _requestErrorController.close();
  }
  
  // singleton
  static final WishListBloc _instance = WishListBloc._internal();
  factory WishListBloc () => _instance;
  WishListBloc._internal();
}

WishListBloc wishListBloc = WishListBloc();