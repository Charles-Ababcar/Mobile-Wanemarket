import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/article/article_bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/string-cut.dart';
import 'package:mobile_frontend/common/material/round-button.dart';
import 'package:mobile_frontend/common/pages/item/items-description.dart';
import 'package:mobile_frontend/constraints.dart';

class ItemCardOwner extends StatefulWidget {
  final Item item;
  final Function(int) onClick;
  final Function(int) onEdit;
  final Function(int) onLongPress;

  const ItemCardOwner(
      {Key? key,
      required this.item,
      required this.onClick,
      required this.onEdit,
      required this.onLongPress}
  );

  @override
  State<StatefulWidget> createState() => _ItemCardOwner(this.item.isAvailable!);
}

class _ItemCardOwner extends State<ItemCardOwner> {
  ArticleBloc bloc = new ArticleBloc();
  bool isAvailable = false;

  _ItemCardOwner(bool available) {
    this.isAvailable = available;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // TODO: implement build
    return InkWell(

        onTap: () {
          widget.onClick(widget.item.id!);
        },

        child: Container(
            height: 60,
            width: size.width,
            margin: EdgeInsets.only(bottom: 10),

            /**
             * Decoration of card
             */
            decoration: BoxDecoration(
                color: yellowSemi,
                // color: yellowSemi,
                borderRadius : new BorderRadius.all(const Radius.circular(15.0))
            ),

            child: Row(
              children: [

                /**
                 * title name
                 */
                getItemName(),

                /**
                 * action buttons
                 */
                getActionButtons()

              ],
            )

        )

    );
  }

  getItemName() {
    return Container(
      padding: EdgeInsets.only(left: 15),
      child: Text(StringWrapper.cut("${widget.item.title}", 15)!,
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)
      ),
    );
  }

  getActionButtons() {
    return Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              /**
               * switch for visibility
               */
              getSwitch(),

              /**
               * Edit button
               */
              Padding(
                padding: EdgeInsets.all(5),
                child: getEditButton(),
              ),

              /**
               * Delete buttons
               */
              Padding(
                padding: EdgeInsets.all(5),
                child: getDeleteButton(),
              ),

            ],
          ),
        )
    );
  }

  getShowButton() {
    return RoundButton(
      height: 50,
      width: 50,
      icon: Icon(Icons.remove_red_eye_outlined, color: Colors.black,),
      buttonColor: yellowLight,
      callback: () {

      },
    );
  }

  getEditButton() {
    return RoundButton(
      height: 40,
      width: 40,
      icon: Icon(Icons.edit, color: Colors.black, size: 17),
      buttonColor: grayLight,
      callback: () {
        widget.onEdit(widget.item.id!);
      },
    );
  }

  getDeleteButton() {
    return RoundButton(
      height: 40,
      width: 40,
      icon: Icon(Icons.delete, color: Colors.black, size: 17),
      buttonColor: lightPink,
      callback: () {
        widget.onLongPress(widget.item.id!);
      },
    );
  }

  Widget getSwitch() {
    return Switch(
      value: isAvailable,
      activeColor: yellowStrong,


      onChanged: (bool? value) async {

        var hasChanged = await bloc.changeVisibility(widget.item.id!, value!);

        if (hasChanged) {
          setState(() {
            isAvailable = value;
          });
        }

      }

    );
  }

  showItemModalSheet(context, int id) {
    Navigator.push(context, new MaterialPageRoute(
        builder: (BuildContext context) {
          return ItemDescription(itemId: id, isAdmin: false);
        }
    ));/*
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        elevation: 80.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        builder: (context) => ItemDescription(itemId: id, isAdmin: false)
    );*/
  }
}
