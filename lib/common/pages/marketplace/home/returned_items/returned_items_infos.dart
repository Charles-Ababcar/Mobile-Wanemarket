import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/ordered-item/marketplace_sold_items_bloc.dart';
import 'package:mobile_frontend/common/classes/date_formatter.dart';
import 'package:mobile_frontend/common/classes/ordered_item.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/classes/string-cut.dart';
import 'package:mobile_frontend/common/pages/marketplace/home/ordered-items/ordered-item-validation.dart';
import 'package:mobile_frontend/common/pages/marketplace/home/returned_items/returned_items_validation.dart';
import 'package:mobile_frontend/constraints.dart';


class ReturnedItemInfos extends StatefulWidget {


  final OrderedItem? orderedItem;
  const ReturnedItemInfos({Key? key, this.orderedItem}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _ReturnedItemInfos();

}

class _ReturnedItemInfos extends State<ReturnedItemInfos> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Popup.modal(context, ReturnedItemValidationModal(
          confirmCallback: () async {
            await marketplaceSalesBloc.setOrderedItemReturned(widget.orderedItem!.id!);
            marketplaceSalesBloc.loadReturningSales();
            Navigator.pop(context);
          },
        ));
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
          Text(widget.orderedItem!.itemName == null ? "Article inconu": StringWrapper.cut(widget.orderedItem!.itemName!, 20), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
          Text("${widget.orderedItem!.username!} (${widget.orderedItem!.userId})", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
          Text("le ${DateFormatter.formatDateTime(widget.orderedItem!.creationDate!.toString())}"     , style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Cliquez pour nous informer du retour", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
            ],
          )

        ],
      ),

    );
  }

}