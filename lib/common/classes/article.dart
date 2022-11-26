import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/classes/category.dart';
import 'package:mobile_frontend/common/classes/marketplace.dart';
import 'package:mobile_frontend/common/classes/photo.dart';
import 'package:mobile_frontend/common/classes/user.dart';

class Item {

  int     ? id;
  String  ? title;
  double  ? price;
  String  ? description;
  Category? category;
  bool    ? isAvailable;
  DateTime ? creationDate;
  DateTime ? endDate;
  bool     ? inMyLekket = false;
  bool     ? inMyWidhList = false;
  int      ? howManyRequests;

  List<Photo> photos = [];

  List<String> shoesSizeAvailable = [];
  List<String> clothesSizedAvailable = [];
  List<String> colorsAvailable = [];

  String? ownerName;
  String? ownerCity;

  static Item fromJson(data) {

    Item item = new Item();

    item.id              = data["id"];
    item.title           = data["name"];
    item.price           = data["price"];
    item.isAvailable     = data["available"];
    item.description     = data["description"];
    item.inMyLekket        = data["inMyLekket"];
    item.inMyWidhList      = data["inWishList"];
    item.howManyRequests   = data["howManyRequests"];
    item.creationDate      =  DateTime.parse(data["creationDate"]);
    item.endDate           =  data["endDate"] == null ? null: DateTime.parse(data["endDate"]);

    item.category = new Category(
      data["category"]["id"],
      data["category"]["name"]
    );

    // picture
    int pictureSize = data["pictures"].length;

    for(int j = 0; j < pictureSize; ++j) {
      item.photos.add(new Photo(
          data["pictures"][j]["id"],
          data["pictures"][j]["url"]
        )
      );
    }

    // shoes size list
    int shoesSizeLength = data["shoesSizeAvailable"].length;
    for(int i = 0; i < shoesSizeLength; ++i) {
      item.shoesSizeAvailable.add(data["shoesSizeAvailable"][i]);
    }


    // clothes size list
    int clothesSizeLength = data["clothesSizedAvailable"].length;
    for(int i = 0; i < clothesSizeLength; ++i) {
      item.clothesSizedAvailable.add(data["clothesSizedAvailable"][i]);
    }

    // colors list
    int colorsLength = data["colorsAvailable"].length;
    for(int i = 0; i < colorsLength; ++i) {
      item.colorsAvailable.add(data["colorsAvailable"][i]);
    }

    return item;

  }

  static mapAll(data) {

    List<Item> items = [];

    for(int i = 0; i < data.length; ++i) {
      
      Item item = new Item();

      item.id              = data[i]["id"];
      item.title           = data[i]["name"];
      item.price           = data[i]["price"];
      item.isAvailable     = data[i]["available"];
      item.description     = data[i]["description"];
      item.inMyLekket      = data[i]["inMyLekket"];
      item.howManyRequests   = data[i]["howManyRequests"];
      item.creationDate    = DateTime.parse(data[i]?["creationDate"]);
      item.endDate         = data[i]?["endDate"] == null ? null: DateTime.parse(data[i]?["endDate"]);

      item.category = new Category(
        data[i]["category"]["id"],
        data[i]["category"]["name"]
      );

      // picture
      int pictureSize = data[i]["pictures"].length;

      for(int j = 0; j < pictureSize; ++j) {
        item.photos.add(new Photo(
            data[i]["pictures"][j]["id"],
            data[i]["pictures"][j]["url"]
          )
        );
      }

      items.add(item);

    }

    return items;
  }

  // static Item fromJson(data) {
  //
  //   Item item = new Item();
  //
  //   item.id              = data["id"];
  //   item.title           = data["name"];
  //   item.price           = data["price"];
  //   item.isAvailable     = data["available"];
  //   item.description     = data["description"];
  //   item.inMyLekket        = data["inMyLekket"];
  //   item.inMyWidhList      = data["inWishList"];
  //   item.howManyRequests   = data["howManyRequests"];
  //   item.creationDate      =  DateTime.parse(data["creationDate"]);
  //   item.endDate           =  data["endDate"] == null ? null: DateTime.parse(data["endDate"]);
  //
  //   item.category = new Category(
  //       data["category"]["id"],
  //       data["category"]["name"]
  //   );
  //
  //   // picture
  //   int pictureSize = data["pictures"].length;
  //
  //   for(int j = 0; j < pictureSize; ++j) {
  //
  //     ItemPhotoInfo photoInfo = new ItemPhotoInfo();
  //     photoInfo.url = data["pictures"][j]["url"];
  //     photoInfo.id =  data["pictures"][j]["id"];
  //     photoInfo.isDeleted = false;
  //     photoInfo.isNew = false;
  //
  //     item.photos.add(photoInfo);
  //   }
  //
  //   return item;
  //
  // }
  //
  // static mapAll(data) {
  //
  //   List<Item> items = [];
  //
  //   for(int i = 0; i < data.length; ++i) {
  //
  //     Item item = new Item();
  //
  //     item.id              = data[i]["id"];
  //     item.title           = data[i]["name"];
  //     item.price           = data[i]["price"];
  //     item.isAvailable     = data[i]["available"];
  //     item.description     = data[i]["description"];
  //     item.inMyLekket      = data[i]["inMyLekket"];
  //     item.howManyRequests   = data[i]["howManyRequests"];
  //     item.creationDate    = DateTime.parse(data[i]?["creationDate"]);
  //     item.endDate         = data[i]?["endDate"] == null ? null: DateTime.parse(data[i]?["endDate"]);
  //
  //     item.category = new Category(
  //         data[i]["category"]["id"],
  //         data[i]["category"]["name"]
  //     );
  //
  //     // picture
  //     int pictureSize = data[i]["pictures"].length;
  //
  //     for(int j = 0; j < pictureSize; ++j) {
  //
  //       ItemPhotoInfo photoInfo = new ItemPhotoInfo();
  //       photoInfo.url = data["pictures"][j]["url"];
  //       photoInfo.id =  data["pictures"][j]["id"];
  //       photoInfo.isDeleted = false;
  //       photoInfo.isNew = false;
  //
  //
  //       item.photos.add(photoInfo);
  //     }
  //
  //     items.add(item);
  //
  //   }
  //
  //   return items;
  // }


}