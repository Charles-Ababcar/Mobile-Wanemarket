import 'dart:developer';

import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/city.dart';
import 'package:mobile_frontend/common/classes/user.dart';

class ItemLekket {

  int     ? id;
  int     ? quantity;
  Item    ? item;
  String  ? instructions;
  User    ? customer;
  DateTime? requestedDate;
  String ? pickedShoeSize;
  String ? pickedClotheSize;
  String ? pickedColor;

  static List<ItemLekket> mapAll(data) {
    List<ItemLekket> itemLekkets = [];

    for(int i = 0; i < data.length; ++i) {

      ItemLekket itemLekket = new ItemLekket();

      itemLekket.id            = data[i]["id"];
      itemLekket.quantity      = data[i]["quantity"];
      itemLekket.instructions      = data[i]["instructions"];
      itemLekket.requestedDate = DateTime.parse(data[i]["requestedDate"]);
      itemLekket.item          = Item.fromJson(data[i]["annonce"]);

      itemLekket.pickedShoeSize   =  data[i]["pickedShoeSize"];
      itemLekket.pickedClotheSize =  data[i]["pickedClotheSize"];
      itemLekket.pickedColor      =  data[i]["pickedColor"];

      // order.customer      = User.map(data[i]["customer"]);
      itemLekket.customer = new User("", "");
      itemLekket.customer!.id        = data[i]["customer"]["id"];
      itemLekket.customer!.firstName = data[i]["customer"]["firstName"];
      itemLekket.customer!.lastName  = data[i]["customer"]["lastName"];

      itemLekket.customer!.city = new City(
        data[i]["customer"]["city"]["id"], 
        data[i]["customer"]["city"]["localisation"], 
        null
      );
      // inspect(order);
      itemLekkets.add(itemLekket);
    }

    return itemLekkets;
  }

}