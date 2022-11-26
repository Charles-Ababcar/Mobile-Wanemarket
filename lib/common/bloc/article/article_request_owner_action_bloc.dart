import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/purchase_order.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/article_service.dart';
import 'package:mobile_frontend/common/services/firebase/wane_fire_storage.dart';
import 'package:mobile_frontend/common/services/purchase_order_service.dart';
import 'package:mobile_frontend/constraints.dart';

class ArticleRequestActionBloc implements Bloc {

  final _errorController = StreamController<String?>.broadcast();
  Sink<String?>   get errorSink   => _errorController.sink;
  Stream<String?> get errorStream => _errorController.stream;
  

  ///////////////////////////////////
  ///    IMPORT owner artilrd   /////
  ///////////////////////////////////

  Future <void> validateRequest(int purchaseOrderId) async {

    try {
      errorSink.add(null);

       // await PurchaseOrderService.validateRequest(purchaseOrderId);
    
    } on WaneBackException catch(e) {
      errorSink.add(e.message);
    } catch (e, stacktrace) {
      errorSink.add(INTERNAL_ERROR_MESSAGE);
    }

  }


  Future <void> declineRequest(int purchaseOrderId, String reason) async {
    errorSink.add(null);


    try {

       // await PurchaseOrderService.declineRequest(purchaseOrderId, reason);
      
    }  on WaneBackException catch(e) {
      errorSink.add(e.message);
    } catch (e, stacktrace) {
      errorSink.add(INTERNAL_ERROR_MESSAGE);
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
  
}