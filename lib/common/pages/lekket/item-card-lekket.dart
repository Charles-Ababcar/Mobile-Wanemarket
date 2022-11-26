import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/article/article_lekket_action.dart';
import 'package:mobile_frontend/common/bloc/article/article_lekket_edit.dart';
import 'package:mobile_frontend/common/bloc/article/purchase_list_bloc.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/classes/price-format.dart';
import 'package:mobile_frontend/common/classes/purchase_order.dart';
import 'package:mobile_frontend/common/customed-widgets/ConfirmLekketWidget.dart';
import 'package:mobile_frontend/common/material/card-image.dart';
import 'package:mobile_frontend/common/material/item-card/label-item.dart';
import 'package:mobile_frontend/common/material/item-price.dart';
import 'package:mobile_frontend/common/material/round-button.dart';
import 'package:mobile_frontend/common/material/wane-labek.dart';
import 'package:mobile_frontend/common/pages/item/items-description.dart';
import 'package:mobile_frontend/common/pages/lekket/lekket_quantity_form.dart';

// colors
import 'package:mobile_frontend/constraints.dart';

class ItemCardLekket extends StatelessWidget {

  ItemLekketEditBloc itemEditBloc = new ItemLekketEditBloc();
  ItemLekketActionBloc lekketActionBloc = new ItemLekketActionBloc();

  ItemLekket? itemLekket;

  ItemCardLekket(ItemLekket itemLekket) {
    this.itemLekket = itemLekket;
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return GestureDetector(

      onTap: () {
        showItemModalSheet(context, itemLekket!);
      },

      onLongPress: () {
        Popup.modal(context, ConfirmLekketWidget(
          itemLekket: itemLekket!,
          item: itemLekket!.item,
          callback: (int quantity, String shoeSize, String clotheSize, String color, String? instructions) async {
            itemLekket!.quantity = quantity;
            itemLekket!.pickedShoeSize = shoeSize;
            itemLekket!.pickedClotheSize = clotheSize;
            itemLekket!.pickedColor = color;
            itemLekket!.instructions = instructions;
            await lekketActionBloc.edit(itemLekket!);
            lekketListBloc.loadUserLekket();
          },));
      },

      child: Stack(
        children: [
          getContainer2(size),

          Positioned(
            bottom: 10,
            right: 10,
            child: RoundButton(
              buttonColor: lightRed,
              icon: Icon(Icons.delete),
              height: 50,
              width: 50,

              callback: () {
                showDialog(
                  context: context,
                  builder: (context) => Popup.confirmRemoveLekket(context, () async {
                    this.deleteFromLekket();
                }));
              },

            ),
          ),

        ],
      )

    );
  }

  getContainer2(Size size) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: size.width,
      height: 190,

      decoration: BoxDecoration(
        // // color: yellowSemi,//Colors.white,
        // borderRadius: BorderRadius.circular(30),

        border: Border(
          bottom: BorderSide(width: 1.0, color: grayLight),
        ),

      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          // titre article
          Center(child: Text("${itemLekket!.item!.title}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),),
          Center(child: Text("${PriceFormat.formatePrice(itemLekket!.quantity! * itemLekket!.item!.price!)}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),),),

          // image + buttons
          Row(
            children: [
              // image
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    CardImage(item: itemLekket!.item!, height: 100, width: 100,),
                    SizedBox(height: 10,),
                    Text("${PriceFormat.formatePrice(itemLekket!.item!.price!)}")
                  ],
                )
              ),

              Column(
                children: [
                  Row(
                    children: [
                      RoundButton(
                        buttonColor: grayLight,//Colors.white,
                        icon: Icon(Icons.remove, size: 13,),
                        width: 40,
                        height: 40,
                        callback: () {
                          decrementQuantity();
                        },
                      ),
                      SizedBox(width: 15,),
                      Text("${itemLekket!.quantity}", style: TextStyle(fontSize: 18),),
                      SizedBox(width: 15,),
                      RoundButton(
                        buttonColor: grayLight,//Colors.white,
                        icon: Icon(Icons.add, size: 13,),
                        width: 40,
                        height: 40,
                        callback: () {
                          incrementQuantity();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

        ],


      ),
    );
  }

  getContainer(Size size) {
    return Container(
        height: 150,
        width: size.width,
        margin: EdgeInsets.only(top: 20),

        /**
         * Decoration of card
         */
        decoration: BoxDecoration(
            color: yellowSemi,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(15.0),
              topRight: const Radius.circular(15.0),
              bottomLeft: const Radius.circular(15.0),
              bottomRight: const Radius.circular(15.0),
            )
        ),

        /**
         * Content of card
         */
        child: Row(children: [

          /**
           * Photo of item
           */
          Expanded(
            flex: 5,
            child: CardImage(item: itemLekket!.item!),
          ),

          /**
           * Data of item
           */
          Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      /**
                       * Title
                       */
                      Text("${itemLekket!.item!.title}",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                          )
                      ),

                      // label item of interval of selling
                      // LabelItem(icon: Icon(Icons.hourglass_bottom, size: 20)       , text: "13/10/2020"),
                      // label item of people who have seen item
                      LabelItem(icon: Icon(Icons.shopping_basket, size: 20)   , text: itemLekket!.quantity.toString()),

                      // label item of price
                      LabelItem(icon: Icon(Icons.attach_money, size: 20)   , text: "${PriceFormat.formatePrice(itemLekket!.item!.price!)}"),

                      // getLabelByStatus(itemLekket!.status!, size)
                      /**
                       * PRICE OF ITEM
                       */
                      ItemPrice(
                        height: 30,
                        width: size.width,
                        price: getTotalAmount(itemLekket!),
                        margin: EdgeInsets.all(5),
                      ),

                    ]
                ),
              )
          )

        ])
    );
  }

  double getTotalAmount(ItemLekket itemLekket) {
    return (itemLekket.quantity)! * (itemLekket.item!.price!);
  }

  Widget getLabelByStatus(String status, Size size) {
    if(status == "WAITING") {
      return StateLabel(
        height: 30,
        width: size.width,
        state: ItemState.DEAL_WAITING,
        margin: EdgeInsets.all(5),
      );
    }

    if(status == "ACCEPTED") {
      return StateLabel(
        height: 30,
        width: size.width,
        state: ItemState.DEAL_WON,
        margin: EdgeInsets.all(5),
      );
    }

    else {
      return StateLabel(
        height: 30,
        width: size.width,
        state: ItemState.DEAL_LOST,
        margin: EdgeInsets.all(5),
      );
    }
  }

  ////////////////////////////////////////////:

  showItemModalSheet(context, ItemLekket itemLekket) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isScrollControlled: true,
      elevation: 80.0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10)
        )
      ),

      builder: (context) => ItemDescription(itemId: itemLekket.item!.id!, itemLekketId: itemLekket.id!, isAdmin: false)
    );
  }

  incrementQuantity() async {
    if(itemLekket!.quantity! < 9) {
      int newQuantity = itemLekket!.quantity! + 1;

      bool isUpdated = await itemEditBloc.changePurchaseOrderQuantity(itemLekket!.id!, newQuantity);

      if(isUpdated) {
        lekketListBloc.loadUserLekket();
      }
    }
  }

  decrementQuantity() async {
    if(itemLekket!.quantity! > 1) {
      int newQuantity = itemLekket!.quantity! - 1;
      bool isUpdated = await itemEditBloc.changePurchaseOrderQuantity(itemLekket!.id!, newQuantity);

      if(isUpdated) {
        lekketListBloc.loadUserLekket();
      }
    }
  }

  deleteFromLekket() async {
    await lekketActionBloc.removeItem(itemLekket!.id!);
    lekketListBloc.loadUserLekket();
  }
}

