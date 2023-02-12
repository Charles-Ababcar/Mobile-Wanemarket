import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/bloc/auth_bloc.dart';

class BackEnd {

  static final String API_BASE_PROD_URL = "test.api.wanemarket.com";
  static final String API_BASE_DEV_URL = "9eb5-2addzz01-e34fe-ecb3-7090-3b3b-6c35-82cb-b114.ngrok.io";
  static final bool isDevMode = false;

  static getHeaders() {
    var headers = null;
    if(applicationState.authToken == null) {
      headers =  {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };
    } else {
      headers = {
        'Content-Type'  : 'application/json',
        'Accept'        : 'application/json',
        "Authorization" : "Bearer ${applicationState.authToken}"
      };
    }
    return headers;
  }

  static Future<http.Response> post(String path, data) async {
    var url = isDevMode ? Uri.http(API_BASE_DEV_URL, path): Uri.https(API_BASE_PROD_URL, path);

    http.Response response = await http.post(
      url, 
      headers: getHeaders(),
      body: json.encode(data)
    );

    if(response.statusCode == 403) {
      print("auth not found");
      // return to auth page
      await applicationState.releaseSession();
      authBloc.authSink.add(false);
    }

    return response;
  }

  static Future<http.Response> getSimple(String path) async {
    var url = isDevMode ? Uri.http(API_BASE_DEV_URL, path): Uri.https(API_BASE_PROD_URL, path);

    http.Response response = await http.get(
      url, 
      headers: getHeaders()
    );

    if(response.statusCode == 403) {
      print("auth not found");
      // return to auth page
      await applicationState.releaseSession();
      authBloc.authSink.add(false);
    }

    return response;
  }

}