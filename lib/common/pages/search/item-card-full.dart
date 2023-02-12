import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/string-cut.dart';
import 'package:mobile_frontend/common/material/card-image.dart';
import 'package:mobile_frontend/common/material/item-card/label-item.dart';
import 'package:mobile_frontend/common/material/item-price.dart';
import 'package:mobile_frontend/common/pages/item/items-description.dart';

// colors
import 'package:mobile_frontend/constraints.dart';

class ItemCardReseach extends StatelessWidget {

  Item? item;

  ItemCardReseach(Item item) {
    this.item = item;
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return InkWell (

      onTap: () {
        showItemModalSheet(context, item!.id!);
      },

      child: Container(
        height: 150,
        width: size.width,
        margin: EdgeInsets.only(top: 20),

        /**
         * Decoration of card
         */
        decoration: BoxDecoration(
          color: yellowLight,
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
            child: CardImage(item: item!),
          ),
          
          /**
           * Data of item
           */
          Expanded(
            flex: 5,
            child: Container(

              decoration: BoxDecoration(
                color: yellowSemi,
                  borderRadius: new BorderRadius.only(
                    // topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0),
                    // bottomLeft: const Radius.circular(15.0),
                    bottomRight: const Radius.circular(15.0),
                  )
              ),

              padding: EdgeInsets.all(5),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                
                children: [
                
                  /**
                   * Title
                   */
                  Text("${StringWrapper.cut(item!.title!, 20)}",
                    style: TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.bold
                    )
                  ),

                  // how many puctyres
                  LabelItem(icon: Icon(Icons.category, size: 20) , text: "${StringWrapper.cut(item!.category!.title!, 20)}"),

                  // how many puctyres
                  LabelItem(icon: Icon(Icons.burst_mode, size: 20) , text: "${item!.photos.length}"),

                  // label item of people who have seen item
                  // LabelItem(icon: Icon(Icons.remove_red_eye, size: 20)   , text: "136"),
                  // label item of localisation
                  // LabelItem(icon: Icon(Icons.location_city, size: 20) , text: "${item!.ownerCity}"),

                  /**
                   * PRICE OF ITEM
                   */
                  ItemPrice(
                    height: 30,
                    width: size.width,
                    price: item!.price!,
                    margin: EdgeInsets.all(5),
                  )

                ]),
            )
          )

        ])

      )

    );
  }

  showItemModalSheet(context, int id) {
    Navigator.push(context, new MaterialPageRoute(
        builder: (BuildContext context) {
          return ItemDescription(itemId: id, isAdmin: false);
        }
    ));
  }

}