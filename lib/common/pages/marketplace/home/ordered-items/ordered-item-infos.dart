import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/ordered-item/marketplace_sold_items_bloc.dart';
import 'package:mobile_frontend/common/classes/date_formatter.dart';
import 'package:mobile_frontend/common/classes/ordered_item.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/classes/string-cut.dart';
import 'package:mobile_frontend/constraints.dart';

import 'ordered-item-validation.dart';


class OrderedItemInfos extends StatefulWidget {


  final OrderedItem? orderedItem;
  const OrderedItemInfos({Key? key, this.orderedItem}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderedItemInfos();

}

class _OrderedItemInfos extends State<OrderedItemInfos> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [

        GestureDetector(
          onTap: () {
            Popup.modal(context, OrderedItemValidationModal(
              actionCallback: () async {
                await marketplaceSalesBloc.setOrderedItemAvailable(widget.orderedItem!.id!);
                marketplaceSalesBloc.loadSoldSales();
                Navigator.pop(context);
              },
            ));
          },

          child: getCard(size),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          ],
        ),

        Positioned(
          right: 20,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("le ${DateFormatter.formatDateTime(widget.orderedItem!.creationDate!.toString())}"     , style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
              Text("Cliquez pour faire livrer cet article", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
            ],
          ),
        )
      ],
    );
  }

  getCard(size) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      height: widget.orderedItem!.instructions == null  ? 100 : 180,
      width: size.width,
      decoration: BoxDecoration(
          color: yellowSemi, borderRadius: new BorderRadius.circular(20)
      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.orderedItem!.itemName == null ? "Article inconu" : StringWrapper.cut(widget.orderedItem!.itemName!, 20), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),

          Text("${widget.orderedItem!.username!} (${widget.orderedItem!.userId})", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),

          widget.orderedItem!.instructions == null ? SizedBox(height: 0,) : Container(
            child: Text("Indications:", style: TextStyle(
                fontWeight: FontWeight.bold
            ),),
          ),

          widget.orderedItem!.instructions == null ? SizedBox(height: 0,) : Container(
            child: Text(widget.orderedItem!.instructions!, style: TextStyle(
                fontWeight: FontWeight.w300
            ),),
          ),



        ],
      ),
    );
  }
}