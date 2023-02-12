
import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/purchase_order.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/article_service.dart';
import 'package:mobile_frontend/common/services/purchase_order_service.dart';
import 'package:mobile_frontend/constraints.dart';

class ItemLekketActionBloc implements Bloc {

  ///
  /// lekket add
  ///
  final _lekketAddController = StreamController<bool? >.broadcast();
  Sink< bool? >   get lekketAddSink   => _lekketAddController.sink;
  Stream< bool? > get lekketAddStream => _lekketAddController.stream;

  Future<void> addItem(int itemId, int quantity, String shoeSize, String clotheSize, String color, String? instructions) async {
    lekketAddSink.add(false);
    try {
        await LekketService.addItem(itemId, quantity, shoeSize, clotheSize, color, instructions);
        lekketAddSink.add(true);
      } on WaneBackException catch(e) {
      var error = e.message;
      lekketAddSink.add(false);
    } catch (e, stacktrace) {
      lekketAddSink.add(false);
    }
  }

  Future<void> edit(ItemLekket itemLekket) async {
    lekketAddSink.add(false);
    try {
      await LekketService.edit(itemLekket);
      lekketAddSink.add(true);
    } on WaneBackException catch(e) {
      var error = e.message;
      lekketAddSink.add(false);
    } catch (e, stacktrace) {
      lekketAddSink.add(false);
    }
  }

  ///
  /// lekket remove
  ///

  final _lekketRemoveController = StreamController<bool? >.broadcast();
  Sink< bool? >   get lekketRemoveSink   => _lekketRemoveController.sink;
  Stream< bool? > get lekketRemoveStream => _lekketRemoveController.stream;

  Future<void> removeItem(int itemId) async {
    lekketRemoveSink.add(false);
    try {
      await LekketService.removeItem(itemId);
      lekketRemoveSink.add(true);
    } on WaneBackException catch(e) {
      var error = e.message;
      lekketRemoveSink.add(false);
    } catch (e, stacktrace) {
      lekketRemoveSink.add(false);
    }
  }


  @override
  void dispose() {
    _lekketAddController.close();
  }
  
}