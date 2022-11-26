import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/bloc/user_data_bloc.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc.dart';

/**
 * bloc qui affiche form connexion ou 
 * interieur appli si connecté
 */
class AuthBloc implements Bloc {
  
  // stream user
  final _authController = StreamController<bool?>.broadcast();
  Sink<bool?>   get authSink   => _authController.sink;
  Stream<bool?> get authStream => _authController.stream;

  // stream loginError
  final _loginErrorController = StreamController<String?>.broadcast();
  Sink<String?>   get loginErrorSink   => _loginErrorController.sink;
  Stream<String?> get loginErrorStream => _loginErrorController.stream;

  final _loadingController = StreamController<bool?>.broadcast();
  Sink  <bool?> get loadingSink   => _loadingController.sink;
  Stream<bool?> get loadingStream => _loadingController.stream;

  /////////////////////////////////////////
  ///////////////// LOGIC /////////////////
  /////////////////////////////////////////

  /// vérifie s'il peut récupérer la connexion
  Future<void> init() async {
    print("authBloc.init()");

    bool tokenExists = applicationState.authToken != null;

    if(tokenExists) {
      print("Token d'authentification trouvé => Bienvenue");

      userDataBloc.loadUserFromRemote();
      authSink.add(true);
    } else {
      print("Token d'authentification non trouvé => Connexion");
      authSink.add(false);
      // applicationState.releaseSession();
    }
  }

  // authentifier
  Future<bool?> authenticate(String? phone, String? password) async {
    try {
      //User user = await 
      loadingSink.add(true);
      await AuthService.auth(phone, password);

      /**
       * sink to change screen to 
       * auth pages
       * null: loading
       * false: no auth
       * true: auth
       */
      bool isAuth = applicationState.authToken != null;

      if(isAuth) {
        loadingSink.add(false);

        // get back to welcome page
        authSink.add(true);
        return true;
      } else throw new WaneBackException("Connexion échouée, veuillez nous excuser");

    } on WaneBackException catch(e) {
      var error = e.message;
      loginErrorSink.add(error);
      loadingSink.add(false);
      return false;

    } catch (e, stacktrace) {
      var error = "Erreur interne. Veuillez nous excuser";
      // error = e.toString();

      print("Error: ${e.toString()}");
      print("Stacktrace: ${stacktrace}");
      inspect(e);

      loginErrorSink.add(error);
      loadingSink.add(false);
      return false;
    }
  }

  // lacher la connexion
  Future<void> releaseAuth() async {
    try {
      
      // await AuthService.unAuth();
      applicationState.releaseSession();

      // get back to auth page
      authSink.add(false);

    } on WaneBackException catch(e) {
      print("Wané exeption");
    } catch (e, stacktrace) {
      print("Exception");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    this._loadingController.close();
  }

  // singleton
  static final AuthBloc _instance = AuthBloc._internal();
  factory AuthBloc () => _instance;
  AuthBloc._internal();
}

AuthBloc authBloc = AuthBloc();