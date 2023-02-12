import 'dart:async';

import 'package:mobile_frontend/common/classes/solde.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/solde_service.dart';
import 'package:mobile_frontend/constraints.dart';

import '../bloc.dart';

class SoldeDebitBloc extends Bloc {

  // ----------------------------------------------------------

  // stream loginError
  final _errorDebitController = StreamController<String?>.broadcast();
  Sink<String?>   get errorDebitSink   => _errorDebitController.sink;
  Stream<String?> get errorDebitStream => _errorDebitController.stream;

  Future<bool> debitAmount(double amount) async {
    try {
      errorDebitSink.add(null);
      await SoldeService.createDebitOperation(amount);
      return true;
    }  on WaneBackException catch(e) {
      var error = e.message;
      errorDebitSink.add(error);
      return false;
    } catch (e, stacktrace) {
      errorDebitSink.add(INTERNAL_ERROR_MESSAGE);
      return false;
    }
  }

  @override
  void dispose() {
    _errorDebitController.close();
  }

}