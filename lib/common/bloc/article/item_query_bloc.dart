import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/article_service.dart';
import 'package:mobile_frontend/constraints.dart';

class ItemQueryBloc implements Bloc {

  // stream user
  final _streamController = StreamController< List<Item>? >.broadcast();
  Sink< List<Item>? >   get sink   => _streamController.sink;
  Stream< List<Item>? > get stream => _streamController.stream;

  // stream loginError
  final _loginErrorController = StreamController< String? >.broadcast();
  Sink<String?>   get loginErrorSink   => _loginErrorController.sink;
  Stream<String?> get loginErrorStream => _loginErrorController.stream;

  /////////////////////////////////////////
  ///////////////// LOGIC /////////////////
  /////////////////////////////////////////

  void initBloc() {
    sink.add(null);
  }


  Future <void> query(keywords) async {
    sink.add(null);

    try {
      List<Item>? items = await ArticleService.loadQueryItems(keywords);

      inspect(items);

      sink.add(items);
    } 
    on WaneBackException catch(e) {
      var error = e.message;
      loginErrorSink.add(error);
    } catch (e, stacktrace) {
      loginErrorSink.add(INTERNAL_ERROR_MESSAGE);   
    }
    
  }

  @override
  void dispose() {
    _streamController.close();
    _loginErrorController.close();
  }

}