// validate lekket
import 'dart:async';

import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/order.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/order_service.dart';
import 'package:mobile_frontend/constraints.dart';

class ValidateLekketBloc extends Bloc {

  final _orderController = StreamController<Order?>.broadcast();
  Sink  <Order?> get orderSink   => _orderController.sink;
  Stream<Order?> get ordertream => _orderController.stream;

  final _errorController = StreamController<String>.broadcast();
  Sink  <String> get errorSink   => _errorController.sink;
  Stream<String> get errorStream => _errorController.stream;

  Future<void> validateLekket(Order? order) async {
    try {

      order = await OrderService.validateLekket(order!);
      orderSink.add(order);

    } on WaneBackException catch(e) {
      var error = e.message;
      errorSink.add(error);

    } catch (e, stacktrace) {
      print("Error: ${e}");
      print(stacktrace);
      errorSink.add(INTERNAL_ERROR_MESSAGE);
    }
  }

  Future<String?> createPayment(int orderId) async {
    try {
      await OrderService.canPay(orderId);

      String? paymentUrl = await OrderService.paymentRequest(orderId);

      return paymentUrl;
    } on WaneBackException catch(e) {
      var error = e.message;
      errorSink.add(error);

    } catch (e, stacktrace) {
      print("Error: ${e}");
      print(stacktrace);
      errorSink.add(INTERNAL_ERROR_MESSAGE);
    }
  }

  Future<void> checkPaymentStatus(int orderId) async {
    try {

    } on WaneBackException catch(e) {
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
  }

}