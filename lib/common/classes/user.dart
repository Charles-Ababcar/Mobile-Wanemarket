import 'dart:developer';

import 'package:mobile_frontend/common/classes/city.dart';
import 'package:mobile_frontend/common/classes/marketplace.dart';
import 'package:mobile_frontend/common/classes/roles.dart';

class User {

  int        ? id;
  String     ? lastName;
  String     ? firstName;
  String     ? address;
  String     ? phone;
  String     ? password;
  String     ? repeatPassword;
  String     ? confirmCurrentPassword;
  DateTime   ? creationDate;
  City       ? city;

  int? itemCount;
  int? soldItemsCount;

  int orderCount = 0;
  List<Role> ? roles;
  Marketplace? marketplace;
  // not for the moment
  //List<Marketplace>? marketplaces;

  User(String firstName, String lastName) {
    this.lastName  = lastName;
    this.firstName = firstName;
  }
  
  String show() {
    return  
    "first=" + firstName! +
    ", lalst=" + lastName! +
    ", phone=" + phone! +
    ", pass=" + password! +
    ", repeat=" + repeatPassword!;
  }

  static map(data) {
    User user = new User("", "");
    user.id            = data ["user"]["id"];
    user.lastName            = data ["user"]["lastName"];
    user.firstName            = data ["user"]["firstName"];
    user.itemCount      = data["user"]["itemCount"];
    user.soldItemsCount     = data["user"]["soldCount"];
    user.address       = data["user"]["address"];
    user.phone         = data["user"]["phone"];
    user.password      = data["user"]["password"];
    user.creationDate  = DateTime.parse(data["user"]["creationDate"]);
    user.orderCount = data["user"]["orders"].length;

    ///
    /// create city
    ///
    user.city = new City(
      data["user"]["city"]["id"], 
      data["user"]["city"]["localisation"], 
      data["user"]["city"]["population"]
    );

    ///
    /// create roles
    ///
    var adminRolesLength = data!["user"]["adminRoles"].length;
    user.roles = [];
    for(int i = 0; i < adminRolesLength; ++i) {

      user.roles!.add(
        new Role(
          data["user"]["adminRoles"][i]["id"],
          data["user"]["adminRoles"][i]["name"],
          data["user"]["adminRoles"][i]["description"]
        )
      );
    }

    ///
    /// create marketplace 
    ///
    if(data["user"]["marketplaces"].length > 0) {
      user.marketplace = Marketplace.map(data["user"]["marketplaces"][0]);
    }


    return user;
  }

  static mapAllSimple(data) {

    List<User> list = [];
    int length = data!["users"].length;

    print("length ${length}");

    for(int i = 0; i < length; ++i) {
      print("debut iteration ${i}");
      User user = new User("", "");
      user.id            = data["users"][i]["id"];
      user.lastName      = data["users"][i]["lastName"];
      user.firstName     = data["users"][i]["firstName"];
      user.address       = data["users"][i]["address"];
      user.phone         = data["users"][i]["phone"];
      print("fin iteration ${i}");

      list.add(user);
    }

    return list;

  }

}