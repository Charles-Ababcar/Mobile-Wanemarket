import 'dart:async';

import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/ordered_item.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/marketplace_service.dart';
import 'package:mobile_frontend/common/services/back-end/ordered_item_service.dart';
import 'package:mobile_frontend/constraints.dart';

class MarketplaceSalesBloc extends Bloc {


  final _errorController = StreamController<String>.broadcast();

  Sink <String> get errorSink => _errorController.sink;

  Stream<String> get errorStream => _errorController.stream;

  // ----------------------------------------------------------------------------

  final _soldItemsController = StreamController<List<OrderedItem>?>.broadcast();
  Sink <List<OrderedItem>?>  get soldItemsSink => _soldItemsController.sink;
  Stream<List<OrderedItem>?> get soldItemsStream => _soldItemsController.stream;

  Future<void> loadSoldSales() async {
    soldItemsSink.add(null);

    try {
      final String STATUS = "PAID";

      List<OrderedItem>? orderedItems = await MarketplaceService
          .findSalesByStatus(STATUS);
      soldItemsSink.add(orderedItems);

    } on WaneBackException catch (e) {
      var error = e.message;
      errorSink.add(error);
    } catch (e, stacktrace) {
      print("Error: ${e}");
      print(stacktrace);
      errorSink.add(INTERNAL_ERROR_MESSAGE);
    }
  }

  Future<void> setOrderedItemAvailable(int orderedItemId) async {
    try {

      await OrderedItemService.setOrderedItemAvailable(orderedItemId);

    } on WaneBackException catch (e) {
      var error = e.message;
      errorSink.add(error);
    } catch (e, stacktrace) {
      print("Error: ${e}");
      print(stacktrace);
      errorSink.add(INTERNAL_ERROR_MESSAGE);
    }
  }

  // ----------------------------------------------------------------------------

  final _returningItemsController = StreamController<List<OrderedItem>?>.broadcast();

  Sink <List<OrderedItem>?> get returningItemsSink => _returningItemsController.sink;
  Stream<List<OrderedItem>?> get returningItemsStream => _returningItemsController.stream;

  Future<void> loadReturningSales() async {
    returningItemsSink.add(null);
    try {
      final String STATUS = "RETURN_IN_PROGRESS";

      List<OrderedItem>? orderedItems = await MarketplaceService
          .findSalesByStatus(STATUS);
      returningItemsSink.add(orderedItems);
    } on WaneBackException catch (e) {
      var error = e.message;
      errorSink.add(error);
    } catch (e, stacktrace) {
      print("Error: ${e}");
      print(stacktrace);
      errorSink.add(INTERNAL_ERROR_MESSAGE);
    }
  }

  Future<void> setOrderedItemReturned(int orderedItemId) async {
    try {
      await OrderedItemService.setOrderedItemReturned(orderedItemId);
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
    _soldItemsController.close();
    _returningItemsController.close();
    _errorController.close();
  }

  // singleton
  static final MarketplaceSalesBloc _instance = MarketplaceSalesBloc._internal();
  factory MarketplaceSalesBloc () => _instance;
  MarketplaceSalesBloc._internal();
}

MarketplaceSalesBloc marketplaceSalesBloc = MarketplaceSalesBloc();