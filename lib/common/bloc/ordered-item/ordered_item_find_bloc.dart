import 'dart:async';

import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/ordered_item.dart';
import 'package:mobile_frontend/common/services/back-end/ordered_item_service.dart';
import 'package:mobile_frontend/constraints.dart';

import '../../exception/wane_exception.dart';

class OrderedItemFindBloc extends Bloc {

  final _orderedItemController = StreamController<OrderedItem>.broadcast();
  Sink <OrderedItem> get orderedItemSink => _orderedItemController.sink;
  Stream<OrderedItem> get orderedItemStream => _orderedItemController.stream;

  final _errorController = StreamController<String>.broadcast();
  Sink <String> get errorSink => _errorController.sink;
  Stream<String> get errorStream => _errorController.stream;

  Future<void> loadOrderedItemById(int orderedItemId) async {
    try {
      OrderedItem? orderedItems = await OrderedItemService.findOrderedItemById(orderedItemId);
      orderedItemSink.add(orderedItems!);
    } on WaneBackException catch (e) {
      var error = e.message;
      errorSink.add(error);
    } catch (e, stacktrace) {
      print("Error: ${e}");
      print(stacktrace);
      errorSink.add(INTERNAL_ERROR_MESSAGE);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _orderedItemController.close();
    _errorController.close();
  }

}