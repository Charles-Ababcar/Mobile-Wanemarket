import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/order/customer_order_histories_bloc.dart';
import 'package:mobile_frontend/common/classes/date_formatter.dart';
import 'package:mobile_frontend/common/classes/order.dart';
import 'package:mobile_frontend/common/classes/ordered_item.dart';
import 'package:mobile_frontend/common/classes/price-format.dart';
import 'package:mobile_frontend/common/classes/string-cut.dart';
import 'package:mobile_frontend/common/customed-widgets/ordered-item-card.dart';
import 'package:mobile_frontend/common/material/dropdown.dart';
import 'package:mobile_frontend/common/material/empty-wave.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/constraints.dart';

class OrderList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrderList();
}

class _OrderList extends State<OrderList> {

  OrderHistoryBloc orderHistoryBloc = new OrderHistoryBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderHistoryBloc.loadCustomerOrders();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    orderHistoryBloc.dispose();
  }

  int? currentOrderId = -1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
      body: Container(
      padding: EdgeInsets.only(top: 20, right: 10, left: 10),
      child: Column(
        children: [

          /**
           * dropdown to choose order
           * stream waiting for user orders
           */
          StreamBuilder<List<Order?>> (
            stream: orderHistoryBloc.orderStream,
            initialData: null,
            builder: (context, snapshot) {
              if(snapshot.data == null) {
                return Container(
                  height: size.height * 0.9,
                  width: size.width,
                  child: Center(
                    child: EmptyWave(
                      icon: Icons.shopping_basket,
                      text: "Vous n'avez rien acheté",
                    ),
                  ),
                );
              } else {
                orderHistoryBloc.findOrder(snapshot.data![0]!.id!);
                orderHistoryBloc.loadOrderedItemsByOrder(snapshot.data![0]!.id!);
                return getDropdown(snapshot.data!);
              }
            },
          ),

          /**
           * list of ordered item
           * stream waiting for orderedItems
           * after user choose order
           */
          StreamBuilder<Order?> (
            stream: orderHistoryBloc.orderDetailsStream,
            initialData: null,
            builder: (context, snapshot) {
              if(snapshot.data == null) {
                return SizedBox(height: 0,);
              } else {
                return getOrderDetails(snapshot.data!, size);
              }
            },
          ),

          /**
           * list of ordered item
           * stream waiting for orderedItems
           * after user choose order
           */
          StreamBuilder<List<OrderedItem?>> (
            stream: orderHistoryBloc.orderedItemsStream,
            initialData: null,
            builder: (context, snapshot) {
              if(snapshot.data == null) {
                return SizedBox(height: 0,);
              } else {
                print("number of ordered items ${snapshot.data!.length}");
                return getOrderedItemList(size, snapshot.data!);
              }
            },
          ),

        ],
      ),
    ));
  }

  getDropdown(List<Order?> orders) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Dropdown(
        pickedValue: orders[0]!.id.toString(),
        whenOnChange: (String newValue) {
          int newOrderId = int.parse(newValue);
          currentOrderId = newOrderId;
          // find orderedItems from order to show the listt
          orderHistoryBloc.findOrder(currentOrderId!);
          orderHistoryBloc.loadOrderedItemsByOrder(currentOrderId!);
        },

        items: orders.map<DropdownMenuItem<String>>((Order? order) {
          return DropdownMenuItem<String>(
            value: order!.id.toString(),
            child: Text(
                "N°${order.id} - ${DateFormatter.formatDate(order.creationDate.toString())}"),
          );
        }).toList(),

      )
    );
  }

  getOrderedItemList(Size size, List<OrderedItem?> orderedItems) {
    return Expanded(
      child: ListView(
          scrollDirection: Axis.vertical,
          children: orderedItems.map<Widget> ((OrderedItem? orderedItem) {
            return new OrderedItemCard(orderedItem: orderedItem!,);
          }).toList()
      )
    );
  }

  getOrderDetails(Order order, size) {
    return Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("N° de commande: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            Text("${order.id!}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Statut: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            Text("${getStatus(order)}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          ],
        ),


        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Date: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            Text("${DateFormatter.formatDateTime(order.creationDate.toString())}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          ],
        ),


        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("N° de Tél.: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            Text("${order.phone}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Adresse: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            Text("${order.address}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          ],
        ),


        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            Text("${PriceFormat.formatePrice(order.totalAmount!)}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
          ],
        ),

        SizedBox(height: 15,),
        order.instructions == "" ? Container() : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Instructions de livraison", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Container(
              width: size.width,
              child: Text("${order.instructions}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            )
          ],
        ),


      ],
    );
  }

  getStatus(Order order) {
    if(order.status == "VALIDATED") return "Validée";
    if(order.status == "PAID"     ) return "Payée";
    if(order.status == "CREATED"  ) return "En attente de paiement";
    if(order.status == "CANCELLED") return "Annulée par Wanémarket";
  }

}