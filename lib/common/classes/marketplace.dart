import 'dart:developer';

import 'package:mobile_frontend/common/classes/city.dart';

class Marketplace {

  int     ? id;
  String  ? name;
  String  ? description;
  String  ? phone;
  String  ? address;
  City    ? location;
  DateTime? creationDate;
  String  ? status;

  static Marketplace map(body) {
    Marketplace marketplace = new Marketplace();

    marketplace.id           = body["id"];
    marketplace.name         = body["name"];
    marketplace.phone        = body["phone"];
    marketplace.address      = body["address"];
    marketplace.description  = body["description"];
    marketplace.creationDate = DateTime.parse(body["creationDate"]);
    marketplace.status       = body["status"];

    if(body["location"] != null) {
      marketplace.location = new City(
        body["location"]["id"], 
        body["location"]["localisation"], 
        body["location"]["population"]
      );
    }

    return marketplace;
  }

}