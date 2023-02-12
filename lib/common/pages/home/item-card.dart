import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/article/article_description_bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/price-format.dart';
import 'package:mobile_frontend/common/classes/string-cut.dart';
import 'package:mobile_frontend/common/material/card-image.dart';
import 'package:mobile_frontend/common/material/item-price.dart';
import 'package:mobile_frontend/common/material/round-button.dart';
import 'package:mobile_frontend/common/pages/item/items-description.dart';

// consts
import 'package:mobile_frontend/constraints.dart';


/**
 * CLASS WHO CONTAINS A LIST OF ITEM
 * BY CATEGORY
 */
class ItemCardHome extends StatelessWidget {

  Item? item;
  ArticleDescriptionBloc articleDescriptionBloc = new ArticleDescriptionBloc();

  ItemCardHome(Item? item) {
    this.item = item;
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    double height =  120;
    double width = size.width * 0.40;

    return Stack(
      children: [
        getContainer(context, height, width),
      ],
    );

  }

  getContainer(context, height, width) {
    return Container(
        margin: EdgeInsets.all(5),
        // color: yellowSemi,//Colors.white,
        width: width,

        child: GestureDetector(


          onTap: () {
            // push to item details page
            showItemModalSheet(context, item!.id!);
          },


          child: Column(
              children: [

                /**
                 * PHOTO
                 */
                Container(
                    height: 150,
                    width: width,

                    /**
                     * Decoration of card
                     */
                    decoration: BoxDecoration(
                        color: yellowLight,
                        borderRadius: new BorderRadius.all(const Radius.circular(15.0))
                    ),

                    // child: (this.item!.photos.length > 0 )
                    //   ? Image.network(this.item!.photos[0].url!, fit: BoxFit.cover)
                    //   : Image.asset(WANE_LOGO, fit: BoxFit.contain)

                    child: CardImage(item: this.item)
                ),

                /**
                 * TITLE OF ITEM
                 */
                Container(
                  child: Text( StringWrapper.cut(this.item!.title!, 15)  , style: TextStyle(fontSize: 13),),
                  margin: EdgeInsets.all(7),
                ),

                /**
                 * PRICE OF ITEM
                 */
                ItemPrice(
                  height: 30,
                  width: width,
                  price: this.item!.price!,
                  margin: EdgeInsets.all(0),
                  fontSize: 18,
                )

              ]
          ),

        )


    );
  }

  showItemModalSheet(context, int id) {
    Navigator.push(context, new MaterialPageRoute(
        builder: (BuildContext context) {
          return ItemDescription(itemId: id, isAdmin: false);
        }
    ));
    /*
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

      builder: (context) => ItemDescription(itemId: id, isAdmin: false)
    );*/
  }

  getAddFavoriteButton() {
    return RoundButton(
      height: 30,
      width: 30,
      buttonColor: lightRed,
      icon: Icon(Icons.favorite_border, size: 20,),
      callback: () {
        print("clicked to add to favorite");
      },
    );
  }

}