import 'dart:convert';
import 'dart:developer';

import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_frontend/common/classes/item_photo_info.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/service_backend.dart';

class ArticleService {

  static Future<List<Item>?> findItemsByCategory(int itemId, int limit) async {
    var URI = "annonce/find/category/${itemId}/limit/${limit}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      List<Item> items = Item.mapAll(body!["annonces"]);
      return items;
    }
    if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error")
          ? body["error"].toString()
          : "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<List<Item>?> addWishLish(int itemId) async {
    var URI = "annonce/wishes/add/${itemId}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    inspect(response);

    if (response.statusCode != 200) {
      throw new Exception();
    }
  }

  static Future<List<Item>?> removeWishLish(int itemId) async {
    var URI = "annonce/wishes/remove/${itemId}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(response.body);

    inspect(response);

    if (response.statusCode != 200) {
      throw new Exception();
    }
  }

  static Future<List<Item>?> loadWishList() async {
    var URI = "annonce/wishes/mine";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      List<Item> items = Item.mapAll(body!["wishes"]);
      return items;
    }
    if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error")
          ? body["error"].toString()
          : "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<List<Item>?> loadQueryItems(keywords) async {
    var URI = "annonce/query/${keywords}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      List<Item> items = Item.mapAll(body!["annonces"]);
      return items;
    }
    if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error")
          ? body["error"].toString()
          : "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<List<Item>> loadOwnerItems() async {
    var URI = "account/data/annonces";

    http.Response response = await BackEnd.getSimple(URI);

    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      List<Item> items = Item.mapAll(body!["annonces"]);
      return items;
    }
    if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error")
          ? body["error"].toString()
          : "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<void> deleteImageFromArticle(
      int? annonceId, ItemPhotoInfo itemPhotoInfo) async {
    if (itemPhotoInfo.id == null) {
      throw new WaneBackException("Erreur, photo inexistante");
    }

    var URI = "annonce/${annonceId}/picture/remove/${itemPhotoInfo.id}";

    http.Response response = await BackEnd.getSimple(URI);

    if (response.statusCode != 200) {
      throw new WaneBackException("Erreur dans la suppression des photos.");
    }
  }

  static Future<void> sendImagesForArticle(int? articleId, String url) async {
    var data = {"id": null, "url": url};

    var URI = "annonce/picture/add/${articleId}";

    http.Response response = await BackEnd.post(URI, data);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode != 200) {
      throw new WaneBackException("Erreur d'importation des photos.");
    }
  }

  static Future<void> updateItem(Item item) async {
    var data = {
      "name"                  : item.title.toString(),
      "price"                 : item.price,
      "description"           : item.description.toString(),
      "category"              : {"id": item.category!.id},
      "shoesSizeAvailable"    : item.shoesSizeAvailable,
      "clothesSizedAvailable" : item.clothesSizedAvailable,
      "colorsAvailable"       : item.colorsAvailable
    };

    var URI = "annonce/update/${item.id}";

    http.Response response = await BackEnd.post(URI, data);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return; //body!["annonce"]["id"];
    }
    if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error")
          ? body["error"].toString()
          : "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<int> sendArticleRequest(int? marketplaceId, Item item) async {
    var data = {
      "name"                  : item.title.toString(),
      "price"                 : item.price,
      "description"           : item.description.toString(),
      "category"              : {"id": item.category!.id},
      "shoesSizeAvailable"    : item.shoesSizeAvailable,
      "clothesSizedAvailable" : item.clothesSizedAvailable,
      "colorsAvailable"       : item.colorsAvailable
    };

    var URI = "annonce/create/${marketplaceId}";

    http.Response response = await BackEnd.post(URI, data);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return body!["annonce"]["id"];
    }
    if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error")
          ? body["error"].toString()
          : "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<Item> loadOneItemAdmin(int? itemId) async {
    var URI = "";

    URI = "monitoring/annonces/find/${itemId!}";

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      Item item = Item.fromJson(body!["annonce"]);
      item.ownerName = body["marketplaceName"];
      item.ownerCity = body["marketplaceCity"];

      return item;
    }
    if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error")
          ? body["error"].toString()
          : "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<Item> loadOneItem(int? itemId) async {
    var URI = "";

    print("authToken '${applicationState.authToken}' ");

    if (applicationState.authToken != null) {
      URI = "annonce/find/${itemId!}";
    } else {
      URI = "annonce/find/visitor/${itemId}";
    }

    http.Response response = await BackEnd.getSimple(URI);
    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      Item item = Item.fromJson(body!["annonce"]);
      item.ownerName = body["marketplaceName"];
      item.ownerCity = body["marketplaceCity"];

      return item;
    }
    if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error")
          ? body["error"].toString()
          : "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<bool> deleteItem(int itemId) async {
    var URI = "annonce/delete/${itemId}";

    http.Response response = await BackEnd.getSimple(URI);
    inspect(response);

    Map? body = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 400) {
      throw new WaneBackException(body!.containsKey("error")
          ? body["error"].toString()
          : "Erreur interne (2).");
    } else {
      throw new Exception();
    }
  }

  static Future<void> changeVisibility(int itemId, bool visibility) async {
    var URI = "annonce/${itemId}/visibility/${visibility}";
    http.Response response = await BackEnd.getSimple(URI);

    if (response.statusCode != 200) {
      throw new Exception();
    }
  }
}
