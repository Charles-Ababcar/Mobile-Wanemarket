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

class RequestListBloc implements Bloc {

  final _requestListController = StreamController< List<ItemLekket>? >.broadcast();

  Sink  <List<ItemLekket>?> get requestListSink   => _requestListController.sink;
  Stream<List<ItemLekket>?> get requestListStream => _requestListController.stream;
  
  ///////////////////////////////////
  ///    IMPORT owner artilrd   /////
  ///////////////////////////////////

  Future <void> loadRequestList() async {

    requestListSink.add(null);

    try {
    
      // List<PurchaseOrder>? purchaseOrders = (await LekketService.loadRequests());
      // requestListSink.add(purchaseOrders);
    
    } on WaneBackException catch(e) {

    } catch (e, stacktrace) {
      inspect(e);
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _requestListController.close();
  }
  
  // singleton
  static final RequestListBloc _instance = RequestListBloc._internal();
  factory RequestListBloc () => _instance;
  RequestListBloc._internal();
}

RequestListBloc requestListBloc= RequestListBloc();