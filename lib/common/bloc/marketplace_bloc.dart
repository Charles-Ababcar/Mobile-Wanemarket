
import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/marketplace.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/marketplace_service.dart';
import 'package:mobile_frontend/constraints.dart';

class MarketplaceBloc implements Bloc {

  // stream loginError
  final _loginErrorController = StreamController<String?>.broadcast();
  Sink<String?>   get loginErrorSink   => _loginErrorController.sink;
  Stream<String?> get loginErrorStream => _loginErrorController.stream;

  // stream loginError
  final _successRequest = StreamController<bool?>.broadcast();
  Sink<bool?>   get successRequestSink   => _successRequest.sink;
  Stream<bool?> get successRequestStream => _successRequest.stream;

  // loading spin
  final _loadingController = StreamController<bool?>.broadcast();
  Sink  <bool?> get loadingSink   => _loadingController.sink;
  Stream<bool?> get loadingStream => _loadingController.stream;

  /////////////////////////////////////////
  ///////////////// LOGIC /////////////////
  /////////////////////////////////////////

  Future<void> askForMarketplace(Marketplace marketplace) async {
    loginErrorSink.add(null);
    loadingSink.add(true);

    try {

      await MarketplaceService.sendMarketplaceRequest(marketplace);
      successRequestSink.add(true);

    }  on WaneBackException catch(e) {
      var error = e.message;
      loginErrorSink.add(error);
      loadingSink.add(false);
    } catch (e, stacktrace) {
      loginErrorSink.add(INTERNAL_ERROR_MESSAGE);   
      loadingSink.add(false);
    }
    
  }

  @override
  void dispose() {
    _loadingController.close();
    _successRequest.close();
    _loadingController.close();
  }


}