
import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/signup_service.dart';
import 'package:mobile_frontend/constraints.dart';

class ProfileEditBloc implements Bloc {

  User? userTOEdit = applicationState.authUser;

  final _requestErrorController = StreamController<String?>();
  Sink  <String?> get requestErrorsink   => _requestErrorController.sink;
  Stream<String?> get requestErrorstream => _requestErrorController.stream;
  

  ProfileEditBloc() {
    requestErrorsink.add(null);
    loadingSink.add(false);
  }

  // recup users
  // remplir fields
  Future<bool> updateUser(User user) async {
    requestErrorsink.add(null);

    try {
      if(user.password == user.repeatPassword) {
        loadingSink.add(true);

        await SignupService.updateUser(user);
        loadingSink.add(false);
        return true;
      } else {
        requestErrorsink.add("Les deux mots de passes ne correspondent pas");
        return false;
      }
    } on WaneBackException catch(e) {
      loadingSink.add(false);
      requestErrorsink.add(e.message);
      return false;
    } catch (e, stacktrace) {
      loadingSink.add(false);
      requestErrorsink.add(INTERNAL_ERROR_MESSAGE);     
      return false;
    }

  }

  ///
  /// Loaind Stream
  ///
  final _loadingController = StreamController<bool?>();
  Sink  <bool?> get loadingSink   => _loadingController.sink;
  Stream<bool?> get loadingStream => _loadingController.stream;


  @override
  void dispose() {
    // TODO: implement dispose
  }
  
}