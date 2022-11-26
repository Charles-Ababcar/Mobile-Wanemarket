import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/ordered-item/marketplace_sold_items_bloc.dart';
import 'package:mobile_frontend/common/classes/ordered_item.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/constraints.dart';

import 'ordered-item-infos.dart';

class OrderedItemList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrderedItemList();
}

class _OrderedItemList extends State<OrderedItemList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    marketplaceSalesBloc.loadSoldSales();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [

        /**
         * info container about rules
         */
        getInfoContainer(),

        /**
         * list
         */
        StreamBuilder<List<OrderedItem>?>(
          stream: marketplaceSalesBloc.soldItemsStream,
          builder: (context, snapshot) {
            if(snapshot.data == null) {
              return LoadingIcon();
            } else {
              return getOrderedItemList(snapshot.data!, size);
            }
          },
        )
      ],
    );
  }

  getOrderedItemList(List<OrderedItem>? soldItems, Size size) {
    return Expanded(
        child: ListView(
            scrollDirection: Axis.vertical,
            children: soldItems!.map<Widget>((OrderedItem orderedItem) {
              return new OrderedItemInfos(orderedItem: orderedItem,);
            }).toList()));
  }

  getInfoContainer() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: InfoContainer(
          height: 150,
          contentColor: yellowSemi,
          borderColor: yellowStrong,
          icon: Icon(Icons.info_rounded, size: 40, color: yellowStrong,),
          text: Text("Voici vos dernières ventes sur l'application. Quand les colis sont prêts"
              ", cliquez sur une commande et validez pour notifier la livraison.")
      )
    );
  }

}
