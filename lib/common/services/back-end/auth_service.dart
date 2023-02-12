import 'dart:convert';
import 'dart:developer';

import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/service_backend.dart';
import 'package:http/http.dart' as http;

class AuthService {

  /**
   * return token is auth good
   * return exception if problem
   */
  static Future<void> auth(String? phone, String? password) async {

    var data = {
      "phone"         : phone,
      "password"      : password
    };

    // send request
    http.Response response = await BackEnd.post("auth/in", data);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    // handle resposne
    if(response.statusCode == 200) {
      String? token = body!["authToken"];

      await applicationState.storeToken(token!);
      await applicationState.storeUserFromJson(body);
      await applicationState.markIfFirstInstallation();

      return;
    }
    
    else if (response.statusCode == 400 || response.statusCode == 401 || response.statusCode == 403) {
      // decode 
      var error = "Identifiants invalides." ;
      throw new WaneBackException(error);
    } else {
      throw new Exception();
    }
  }

  static Future<bool> isAuthValid() async {
    // send request
    http.Response response = await BackEnd.getSimple("auth/infos");

    // handle response
    if(response.statusCode == 200) {
      return true;
    }

    else if (response.statusCode == 400 || response.statusCode == 401 || response.statusCode == 403) {
      // decode
      return false;
    } else {
      return false;
    }

  }

  static Future<User> getInfos() async {
    // send requestù
    print("ram token ${applicationState.authToken}");
    http.Response response = await BackEnd.getSimple("auth/infos");
    Map? body = json.decode(utf8.decode(response.bodyBytes));
    applicationState.storeUserFromJson(body);

    // handle resposne
    if(response.statusCode == 200) {
      User user = User.map(body);
      return user;
    }

    else if (response.statusCode == 400 || response.statusCode == 401 || response.statusCode == 403) {
      // decode
      var error = "Erreur d'authentification" ;
      throw new WaneBackException(error);
    } else {
      throw new Exception();
    }
  }

}