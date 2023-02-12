
import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/purchase_order.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/article_service.dart';
import 'package:mobile_frontend/common/services/purchase_order_service.dart';
import 'package:mobile_frontend/constraints.dart';

class ItemWishListActionBloc implements Bloc {

  ///
  /// lekket add
  ///
  final _addController = StreamController<bool? >.broadcast();
  Sink< bool? >   get addSink   => _addController.sink;
  Stream< bool? > get addStream => _addController.stream;

  Future<void> addWishLish(int itemId) async {
    addSink.add(false);
    try {
        await ArticleService.addWishLish(itemId);
        addSink.add(true);
      } on WaneBackException catch(e) {
      print("ERROR DURING ADDING WISHLIST");
      var error = e.message;
      addSink.add(false);
    } catch (e, stacktrace) {
      print("ERROR DURING ADDING WISHLIST");
      addSink.add(false);
    }
  }

  ///
  /// lekket remove
  ///
  final _removeController = StreamController<bool? >.broadcast();
  Sink< bool? >   get removeSink   => _removeController.sink;
  Stream< bool? > get removeStream => _removeController.stream;

  Future<void> removeWishLish(int itemId) async {
    removeSink.add(false);
    try {
      await ArticleService.removeWishLish(itemId);
      removeSink.add(true);
    } on WaneBackException catch(e) {
      var error = e.message;
      removeSink.add(false);
    } catch (e, stacktrace) {
      removeSink.add(false);
    }
  }

  @override
  void dispose() {
    _addController.close();
    _removeController.close();
  }
  
}