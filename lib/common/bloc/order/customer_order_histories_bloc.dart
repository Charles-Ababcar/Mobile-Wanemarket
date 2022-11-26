// order list

// order details
import 'dart:async';

import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/order.dart';
import 'package:mobile_frontend/common/classes/ordered_item.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/order_service.dart';
import 'package:mobile_frontend/common/services/back-end/ordered_item_service.dart';
import 'package:mobile_frontend/constraints.dart';

class OrderHistoryBloc extends Bloc {

  final _orderController = StreamController<List<Order?>>.broadcast();
  Sink <List<Order?>> get orderSink => _orderController.sink;
  Stream<List<Order?>> get orderStream => _orderController.stream;

  final _errorController = StreamController<String>.broadcast();
  Sink <String> get errorSink => _errorController.sink;
  Stream<String> get errorStream => _errorController.stream;

  Future<void> loadCustomerOrders() async {
    try {
      List<Order>? orders = await OrderService.findCustomerOrders();

      if(orders!. length > 0) {
        orderSink.add(orders);
      }

    } on WaneBackException catch (e) {
      var error = e.message;
      errorSink.add(error);
    } catch (e, stacktrace) {
      print("Error: ${e}");
      print(stacktrace);
      errorSink.add(INTERNAL_ERROR_MESSAGE);
    }
  }

  final _orderedItemsController = StreamController<List<OrderedItem?>>.broadcast();
  Sink <List<OrderedItem?>> get orderedItemsSink => _orderedItemsController.sink;
  Stream<List<OrderedItem?>> get orderedItemsStream => _orderedItemsController.stream;

  Future<void> loadOrderedItemsByOrder(int orderId) async {
    print("trying to load : ${orderId}");
    try {

      // orderedItemsSink.add([]);
      List<OrderedItem>? orderedItems = await OrderedItemService.findOrderedItemsByOrderId(orderId);
      orderedItemsSink.add(orderedItems!);
    } on WaneBackException catch (e) {
      var error = e.message;
      errorSink.add(error);
    } catch (e, stacktrace) {
      print("Error: ${e}");
      print(stacktrace);
      errorSink.add(INTERNAL_ERROR_MESSAGE);
    }
  }

  // -------------------------------------------------
  // find orders

  final _orderDetailsController = StreamController<Order?>.broadcast();
  Sink  <Order?> get orderDetailsSink => _orderDetailsController.sink;
  Stream<Order?> get orderDetailsStream => _orderDetailsController.stream;

  Future<void> findOrder(int orderId) async {
    try {
      Order? order = await OrderService.orderDetails(orderId);
      orderDetailsSink.add(order!);
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
    _orderController.close();
    _errorController.close();
    _orderedItemsController.close();
  }


}