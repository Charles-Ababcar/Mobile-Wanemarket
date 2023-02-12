import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/ordered-item/marketplace_sold_items_bloc.dart';
import 'package:mobile_frontend/common/classes/ordered_item.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/pages/marketplace/home/ordered-items/ordered-item-infos.dart';
import 'package:mobile_frontend/common/pages/marketplace/home/returned_items/returned_items_infos.dart';
import 'package:mobile_frontend/constraints.dart';

class ReturnedItemsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReturnedItemsList();
}

class _ReturnedItemsList extends State<ReturnedItemsList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    marketplaceSalesBloc.loadReturningSales();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
          stream: marketplaceSalesBloc.returningItemsStream,
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

  getOrderedItemList(List<OrderedItem>? returningItems, Size size) {
    return Expanded(
        child: ListView(
        scrollDirection: Axis.vertical,
        children: returningItems!.map<Widget>((OrderedItem orderedItem) {
          return ReturnedItemInfos(
            orderedItem: orderedItem,
          );
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
            text: Text("Voici tout les produits retournés par les clients.\nUne fois receptionnés, veuillez notifier Wanémarket.\nLes clients seront ensuite remboursés.")
        )
    );
  }
}