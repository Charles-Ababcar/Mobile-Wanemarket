
import 'dart:convert';
import 'dart:developer';

import 'package:mobile_frontend/common/classes/city.dart';
import 'package:mobile_frontend/common/services/back-end/service_backend.dart';
import 'package:http/http.dart' as http;

class CitiesService {


  static Future<List<City>?> getCities() async {
    

    http.Response response = await BackEnd.getSimple("localisation/cities");
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if(response.statusCode == 200) {
      
      List< City >? cities = City.mapAll(body);
      return cities;

    } else {
      throw new Exception();
    }
  }

}