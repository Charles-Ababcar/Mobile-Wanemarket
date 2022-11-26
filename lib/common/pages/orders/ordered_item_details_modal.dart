import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/ordered-item/ordered_item_find_bloc.dart';
import 'package:mobile_frontend/common/classes/order.dart';
import 'package:mobile_frontend/common/classes/ordered_item.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/classes/price-format.dart';
import 'package:mobile_frontend/common/classes/string-cut.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/pages/orders/return-request-modal.dart';
import 'package:mobile_frontend/common/pages/solde/virement_request_modal.dart';
import 'package:mobile_frontend/constraints.dart';

class OrderedItemDetailsModal extends StatefulWidget {

  final OrderedItem orderedItem;
  const OrderedItemDetailsModal({Key? key, required this.orderedItem}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderedItemDetailsModal();

}

class _OrderedItemDetailsModal extends State<OrderedItemDetailsModal> {

  OrderedItemFindBloc orderedItemFindBloc = new OrderedItemFindBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderedItemFindBloc.loadOrderedItemById(widget.orderedItem.id!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    orderedItemFindBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<OrderedItem> (
      stream: orderedItemFindBloc.orderedItemStream,
      initialData: null,
      builder: (context, snapshot) {
        if(snapshot.data == null) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingIcon()
            ],
          );
        } else {
          return Padding(
              padding: EdgeInsets.only(top: 40, left: 10, right: 10),

              child: Stack(
                children: [
                  getContent(snapshot.data!),

                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: canShowReturnButton() ? getReturnButton(context): SizedBox(height: 0,),
                  ),
                ],
              )

          );
        }
      },
    );

  }

  getContent(OrderedItem orderedItem) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,),

          Text("${StringWrapper.cut(orderedItem.itemName!, 100).replaceAll('\n', '/')}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23)),
          orderedItem.itemDescription == null ? SizedBox(height: 0,) : Text("${StringWrapper.cut(orderedItem.itemDescription!, 100).replaceAll('\n', '/')}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23)),

          SizedBox(height: 10,),
          Text("${PriceFormat.formatePrice(orderedItem.price! * orderedItem.quantity!)}", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),

          SizedBox(height: 5,),
          Text("Statut: ${getStatus(orderedItem.currentStatus!)}", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),

          SizedBox(height: 10,),
          widget.orderedItem.instructions == null ? SizedBox(height: 0,) : Container(
            child: Text("Indications:", style: TextStyle(
                fontWeight: FontWeight.bold
            ),),
          ),

          widget.orderedItem.instructions == null ? SizedBox(height: 0,) : Container(
            child: Text(widget.orderedItem.instructions!, style: TextStyle(
                fontWeight: FontWeight.w300
            ),),
          ),

          SizedBox(height: 30,),
          Text("Historique des actions", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
          SizedBox(height: 10,),

          getHistoryList(orderedItem)
        ]

    );
  }


  getHistoryList(OrderedItem orderedItem) {
    return SizedBox(
      height: 400,
      child: ListView(
          scrollDirection: Axis.vertical,
          children: orderedItem.statusHistories!.map<Widget> ((StatusHistory statusHistory) {
            return Container(
              margin: EdgeInsets.only(bottom: 5),
              padding: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.2, color: Colors.black),
                ),
              ),

              // child: Text("29/04/2020 à 15h46 : Paiement effectué sur Paydunya, reference XDZZDF", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
              child: Text("${StringWrapper.formatDate(statusHistory.statusDate!, true)}: ${statusHistory.description}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
            );
          }).toList())
    );
  }

  getReturnButton(context) {
    return BigButton(
      background: yellowSemi,
      text: Text("Demander un retour produit"
        , style: TextStyle(color: Colors.black),),
      icon: Icon(Icons.keyboard_return, color: Colors.black,),
      callback: () {
        Popup.modal(context, ReturnRequestModal(
          orderedItemId: widget.orderedItem.id!,
        ));
      },
    );
  }

  getCancelButton(context) {
    return BigButton(
      background: yellowSemi,
      text: Text("Annuler cet achat"
        , style: TextStyle(color: Colors.black),),
      icon: Icon(Icons.keyboard_return, color: Colors.black,),
      callback: () {
        // Popup.modal(context, ReturnRequestModal());
      },
    );
  }


  canShowReturnButton() {
    bool isDeliveredState = widget.orderedItem.currentStatus == "DELIVERED";
    return isDeliveredState;
  }

  canShowCancelButton() {
    bool isDeliveredState = widget.orderedItem.currentStatus == "PAID" || widget.orderedItem.currentStatus == "AVAILABLE";
    return isDeliveredState;
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