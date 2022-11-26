
import 'dart:async';

import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/purchase_order_service.dart';
import 'package:mobile_frontend/constraints.dart';

import '../bloc.dart';

class ItemLekketEditBloc extends Bloc {


  ///
  /// lekket change quantity
  ///*
  
  final _lekketQuantityUpdateStream = StreamController<String?>();
  Sink<String?>   get sink => _lekketQuantityUpdateStream.sink;
  Stream<String?> get stream    => _lekketQuantityUpdateStream.stream;
  

  Future<bool> changePurchaseOrderQuantity(int purchaseOrderId, int newQuantity) async{
    
    sink.add(null);

    try {

      await LekketService.changeQuantity(purchaseOrderId, newQuantity);

      return true;
    }  on WaneBackException catch(e) {
      sink.add(e.message);
      return false;
    } catch (e, stacktrace) {
      sink.add(INTERNAL_ERROR_MESSAGE);
      return false;
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _lekketQuantityUpdateStream.close();
  }

}