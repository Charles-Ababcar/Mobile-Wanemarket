import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/classes/order.dart';

class OrderedItemDetails extends StatelessWidget {

  final int? orderedItemId;

  const OrderedItemDetails({Key? key, this.orderedItemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Container(
        padding: EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nom de l'article numéro 1", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23)),

            SizedBox(height: 10,),
            Text("150.000 CFA", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),

            SizedBox(height: 5,),
            Text("Statut: EN COURS DE LIVRAISON", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),

            SizedBox(height: 30,),
            Text("Historique des actions", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),

            SizedBox(height: 30,),

            getHistoryList()

          ],
        ),
      ),
    );

  }

  getHistoryList() {
    List<Order> orders = [];
    return Expanded(
      child: ListView(
          scrollDirection: Axis.vertical,
          children: orders.map<Widget> ((Order order) {
            return Container(
              margin: EdgeInsets.only(bottom: 5),
              padding: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.2, color: Colors.black),
                ),
              ),

              child: Text("29/04/2020 à 15h46 : Paiement effectué sur Paydunya, reference XDZZDF", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
            );
          }).toList()
      ),
    );
  }

}