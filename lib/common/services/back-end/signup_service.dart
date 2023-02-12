import 'dart:developer';

import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'service_backend.dart';

class SignupService {

  /**
   * return null if creation is OK
   * return messahe error when error is 400 or 500
   */
  static Future<void> signUser(User user) async {

    var data = {
      "lastName"      : user.lastName,
      "firstName"     : user.firstName,
      "address"       : user.address,
      "phone"         : user.phone,
      "password"      : user.password,
      "repeatPassword": user.repeatPassword,
      "city": {
        "id": user.city!.id
      }
    };

    http.Response response = await BackEnd.post("user/create", data);
    Map? body = json.decode(utf8.decode(response.bodyBytes));
  
    if(response.statusCode == 200) {
      return;
    }
    if (response.statusCode == 400) {
      // decode 
      throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
    } else {
      throw new Exception();
    }

  }

  static Future<void> updateUser(User user) async {

    var data = {
      "lastName"      : user.lastName,
      "firstName"     : user.firstName,
      "phone"         : user.phone,
      "validateCurrentPassword": user.confirmCurrentPassword == "" ? null: user.confirmCurrentPassword,
      "password"      : user.password       == "" ? null: user.password,
      "repeatPassword": user.repeatPassword == "" ? null: user.repeatPassword,
      "address"       : user.address,
      "city": {
        "id": user.city!.id
      }
    };

    var url = "user/update/" + user.id.toString() + "/";
    http.Response response = await BackEnd.post(url, data);

   // erreur ici
    Map? body = json.decode(utf8.decode(response.bodyBytes));
   
    if(response.statusCode == 200) {
      applicationState.storeUserFromJson(body);

      return;
    } else if (response.statusCode == 400) {
      // decode 
      throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
    } else {
      throw new Exception();
    }

  }

}