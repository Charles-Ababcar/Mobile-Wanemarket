import 'dart:async';
import 'dart:io';

import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/signup_service.dart';
import 'package:mobile_frontend/constraints.dart';

import 'bloc.dart';

/**
 * class qui sert à créer un user
 */
class SignupBloc implements Bloc {

  SignupBloc() {
    this._requestErrorStream.add(null);
    this.isCreatedSink.add(false);
  }

  /**
   * RequestError
   */
  final _requestErrorStream = StreamController<String?>.broadcast();
  Sink<String?>   get reqErrSink   => _requestErrorStream.sink;
  Stream<String?> get reqErrStream => _requestErrorStream.stream;

  /**
   * request response
   */
  final _isCreatedStream = StreamController<bool>();
  Sink<bool>     get isCreatedSink   => _isCreatedStream.sink;
  Stream<bool>   get isCreatedStream => _isCreatedStream.stream;

  Future<bool> signup(User user) async {
    // erase error mess
    this.reqErrSink.add(null);

    try {
      if(user.password == user.repeatPassword) {
        await SignupService.signUser(user);
        // informer a la page signup que l'inscription est faite
        this.isCreatedSink.add(true);
        return true;
      } else {
        this.reqErrSink.add("Les deux mots de passes ne correspondent pas");
        return false;
      }
    } on WaneBackException catch(e) {
      reqErrSink.add(e.message);
      return false;
    } catch (e, stacktrace) {
      reqErrSink.add(INTERNAL_ERROR_MESSAGE);     
      return false;
    }
  }

  @override
  void dispose() {
    this._requestErrorStream.close();
    this._isCreatedStream.close();
  }
  
}