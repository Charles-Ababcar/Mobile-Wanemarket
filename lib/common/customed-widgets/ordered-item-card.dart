import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/classes/ordered_item.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/classes/price-format.dart';
import 'package:mobile_frontend/common/classes/string-cut.dart';
import 'package:mobile_frontend/common/pages/orders/ordered_item_details.dart';
import 'package:mobile_frontend/common/pages/orders/ordered_item_details_modal.dart';
import 'package:mobile_frontend/constraints.dart';

class OrderedItemCard extends StatelessWidget {

  final OrderedItem orderedItem;

  const OrderedItemCard({Key? key, required this.orderedItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {

        Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) {
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: yellowStrong,),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  body: OrderedItemDetailsModal(orderedItem: orderedItem));
              //return  NewItemForm();
            }
        ));

        // Popup.modal(context, );
      },

      child: getCard(size),
    );
  }

  getCard(size) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      height: 100,
      width: size.width,
      decoration: BoxDecoration(
          color: yellowSemi, borderRadius: new BorderRadius.circular(20)
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Achat n°${orderedItem.id}", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17)),
          Text("${StringWrapper.cut(orderedItem.itemName!, 25)}", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17)),
          Text("${getStatus(orderedItem.currentStatus!)}", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("${PriceFormat.formatePrice(orderedItem.price! * orderedItem.quantity!)}", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
            ],
          )
        ],
      ),

    );
  }

  getStatus(String status) {
    if(status == "CREATED") return "En attente de paiement";
    if(status == "PAID") return "Payé";
    if(status == "AVAILABLE") return "Disponible pour livraison";
    if(status == "SHIPPING") return "En livraison";
    if(status == "DELIVERED") return "Livré";
    if(status == "RETURN_REQUEST") return "Retour produit";
    if(status == "RETURN_IN_PROGRESS") return "En cours de retour";
    if(status == "CANCELLED") return "Annulé";
    if(status == "RETURNED") return "Retourné chez l'annonceur";
    if(status == "TERMINATED") return "Livré";
    if(status == "REGISTERED") return "Livré";
  }

}