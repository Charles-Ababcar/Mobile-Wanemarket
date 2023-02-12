import 'dart:convert';
import 'dart:developer';

import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/marketplace.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
 import 'package:mobile_frontend/common/services/back-end/service_backend.dart';
import 'package:http/http.dart' as http;

class MonitoringService {

  ///
  /// handle admin roles
  ///
  static Future<void> toggleAdminRole(int userId, bool value) async {
    var URI = "monitoring/admins/role/admins/${value}/${userId}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if(response.statusCode != 200) {
      if (response.statusCode == 400) {
        throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
      } else {
        throw new Exception();
      }
    }

  }

  static Future<void> toggleAnnonceRole(int userId, bool value) async {
    var URI = "monitoring/admins/role/annonces/${value}/${userId}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if(response.statusCode != 200) {
      if (response.statusCode == 400) {
        throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
      } else {
        throw new Exception();
      }
    }

  }

  static Future<void> annonceDecision(int annonceId, bool value) async {
    var URI = "monitoring/annonces/decide/${value}/${annonceId}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if(response.statusCode != 200) {
      if (response.statusCode == 400) {
        throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
      } else {
        throw new Exception();
      }
    }

  }

  static Future<void> annonceurDecision(int marketplaceId, bool value) async {
    var URI = "monitoring/marketplaces/decide/${value}/${marketplaceId}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if(response.statusCode != 200) {
      if (response.statusCode == 400) {
        throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
      } else {
        throw new Exception();
      }
    }

  }

  static Future<void> toggleAnnonceurRole(int userId, bool value) async {
    var URI = "monitoring/admins/role/marketplaces/${value}/${userId}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if(response.statusCode != 200) {
      if (response.statusCode == 400) {
        throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
      } else {
        throw new Exception();
      }
    }

  }

  static Future<User> findAdmin(int userId) async {
    var URI = "monitoring/admins/find/${userId}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      User user = User.map(body);
      return user;
    } if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<List<User>?> getAdminList() async {
    var URI = "monitoring/admins/list/admins";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      List<User> adminList = User.mapAllSimple(body);
      print("loaded");
      return adminList;
    } if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<List<Marketplace>?> getMarketplaceList() async {
    var URI = "monitoring/marketplaces/list/7";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {

      List<Marketplace> annonceurs = [];

      for(int i = 0; i < body!["marketplaces"].length; ++i) {
        annonceurs.add(Marketplace.map(body["marketplaces"][i]));
      }

      return annonceurs;

    } if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<List<Item>?> getAnnonceList() async {
    var URI = "monitoring/annonces/list/7";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      List<Item> annonces = Item.mapAll(body!["annonces"]);
      return annonces;
    } if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error") ? body["error"].toString(): "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }


}