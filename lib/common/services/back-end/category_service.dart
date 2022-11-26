
import 'dart:convert';
import 'dart:developer';

import 'package:mobile_frontend/common/classes/category.dart';
import 'package:mobile_frontend/common/classes/city.dart';
import 'package:mobile_frontend/common/services/back-end/service_backend.dart';
import 'package:http/http.dart' as http;

class CategoryService {


  static Future<List<Category>?> getCategories() async {
    

    http.Response response = await BackEnd.getSimple("category/list");
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if(response.statusCode == 200) {
      
      List< Category >? categories = Category.mapAll(body);
      return categories;

    } else {
      throw new Exception();
    }
  }

}