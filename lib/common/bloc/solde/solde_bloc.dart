import 'dart:async';

import 'package:mobile_frontend/common/classes/solde.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/solde_service.dart';
import 'package:mobile_frontend/constraints.dart';

import '../bloc.dart';

class SoldeBloc extends Bloc {
  // solde controller
  final _soldeController = StreamController<Solde?>();
  Sink<Solde?> get soldeSink => _soldeController.sink;
  Stream<Solde?> get soldeStream => _soldeController.stream;

  // stream loginError
  final _errorController = StreamController<String?>.broadcast();
  Sink<String?> get errorSink => _errorController.sink;
  Stream<String?> get errorStream => _errorController.stream;

  Future<void> loadUserSolde() async {
    try {
      Solde solde = await SoldeService.findMySolde();
      soldeSink.add(solde);
    } on WaneBackException catch (e) {
      var error = e.message;
      errorSink.add(error);
    } catch (e, stacktrace) {
      errorSink.add(INTERNAL_ERROR_MESSAGE);
    }
  }

  // ----------------------------------------------------------

  // stream loginError
  final _errorDebitController = StreamController<String?>.broadcast();
  Sink<String?> get errorDebitSink => _errorDebitController.sink;
  Stream<String?> get errorDebitStream => _errorDebitController.stream;

  Future<bool> debitAmount(double amount) async {
    try {
      await SoldeService.createDebitOperation(amount);
      return true;
    } on WaneBackException catch (e) {
      var error = e.message;
      errorSink.add(error);
      return false;
    } catch (e, stacktrace) {
      errorSink.add(INTERNAL_ERROR_MESSAGE);
      return false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _soldeController.close();
    _errorController.close();
  }
}
