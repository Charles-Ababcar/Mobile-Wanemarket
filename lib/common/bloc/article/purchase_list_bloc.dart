import 'dart:async';

import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/purchase_order.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/purchase_order_service.dart';
import 'package:mobile_frontend/constraints.dart';

class LekketListBloc extends Bloc {


  final _requestErrorController = StreamController<String?>.broadcast();
  Sink<String?>   get loginErrorSink   => _requestErrorController.sink;
  Stream<String?> get loginErrorStream => _requestErrorController.stream;
  
  final _lekketController = StreamController< List<ItemLekket>? >.broadcast();
  Sink   < List<ItemLekket>? > get lekketSink   => _lekketController.sink;
  Stream < List<ItemLekket>? > get lekketStream => _lekketController.stream;

  Future<void> loadUserLekket() async {

    try {
      List<ItemLekket> orders = (await LekketService.loadLekket())!;
      lekketSink.add(orders);

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
  static final LekketListBloc _instance = LekketListBloc._internal();
  factory LekketListBloc () => _instance;
  LekketListBloc._internal();
}

LekketListBloc lekketListBloc = LekketListBloc();