import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/article/purchase_list_bloc.dart';
import 'package:mobile_frontend/common/classes/price-format.dart';
import 'package:mobile_frontend/common/classes/purchase_order.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/material/empty-wave.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/pages/lekket/item-card-lekket.dart';
import 'package:mobile_frontend/common/pages/payment/order_validation.dart';
import 'package:mobile_frontend/constraints.dart';

class LekketPage extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => _LekketPage();

}

class _LekketPage extends State<LekketPage> with WidgetsBindingObserver {

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    state = state;
    print(state);
    print(":::::::");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    lekketListBloc.loadUserLekket();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    // lekketBloc.dispose();
  }

  getItems() {
    return [];//Item.getItems();
  }

  @override
  Widget build(BuildContext context) {

  Size size = MediaQuery.of(context).size;

   return Container(
   
    height: size.height,
    width: size.width,

    child: StreamBuilder< List<ItemLekket>? > (
      stream: lekketListBloc.lekketStream,
      initialData: null,
      builder: (context, snapshot) {

        if(snapshot.hasData || snapshot.data != null) {
          if(snapshot.data!.length == 0) {
            return EmptyWave(
              icon: Icons.shopping_basket,
              text: "Votre panier est vide",
            );
          } else {
            return Column(
              children: [
                Expanded(child: getListView(snapshot.data!)),

                (snapshot.data?.length == 0) ? Container(): Padding(
                  padding: EdgeInsets.all(10),
                  child: getTotal(snapshot.data!),
                ),
                (snapshot.data?.length == 0) ? Container() : getOrderButton()
              ],
            );
          }
        } else {
          return LoadingIcon();
        }
      },
    ),
   );
  }

  Widget getListView(List<ItemLekket> itemLekkets) {
    return ListView(
        scrollDirection: Axis.vertical,
        children: itemLekkets.map<Widget> ((ItemLekket itemLekket) {
          return ItemCardLekket(itemLekket);
        }).toList()
    );
  }

  getOrderButton() {
    return BigButton(
      background: yellowSemi,
      text: Text("Valider la commande"
          , style: TextStyle(color: Colors.black),),
      icon: Icon(Icons.check, color: Colors.black,),
      callback: () {
        Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) {
              return OrderValidation();
            }
        ));
      },
    );
  }

  getTotal(List<ItemLekket> lekket) {
    double total = 0;
    lekket.forEach((ItemLekket element) {
      total += (element.item!.price! * element.quantity!);
    });

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total commande: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            Text("${PriceFormat.formatePrice(total)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Traitement et livraison: ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            Text("${PriceFormat.formatePrice(600)} - ${PriceFormat.formatePrice(1100)}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

}