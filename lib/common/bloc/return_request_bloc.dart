
import 'dart:async';

import 'package:mobile_frontend/common/classes/return_request.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/return_request.dart';
import 'package:mobile_frontend/constraints.dart';

import 'bloc.dart';

class ReturnRequestBloc implements Bloc {

  // stream loginError
  final _controller = StreamController<bool?>.broadcast();
  Sink<bool?>   get sink   => _controller.sink;
  Stream<bool?> get stream => _controller.stream;

  // Error
  final _errorController = StreamController<String?>.broadcast();
  Sink<String?>   get sinkError   => _errorController.sink;
  Stream<String?> get streamError => _errorController.stream;

  // true: sent
  // false: loading
  // null: nothing
  Future<void> createReturnRequest(ReturnRequest returnRequest) async {
    sinkError.add(null);

    try {
      await ReturnRequestService.createReturnRequest(returnRequest);
      sink.add(true);
    }  on WaneBackException catch(e) {
      var error = e.message;
      sinkError.add(null);
      sinkError.add(error);
    } catch (e, stacktrace) {
      sinkError.add(null);
      sinkError.add(INTERNAL_ERROR_MESSAGE);
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _controller.close();
    _errorController.close();
  }


}