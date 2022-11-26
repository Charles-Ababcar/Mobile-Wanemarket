import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/material/item-price.dart';
import 'package:mobile_frontend/common/pages/item/items-description.dart';
import 'package:mobile_frontend/constraints.dart';

class ItemCardCategory extends StatelessWidget {

  final Item? item;
  final double? height;
  final double? width;

  const ItemCardCategory({Key? key, required this.item, this.height, this.width}): super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(

      onTap: () {
        // item details push
        showItemModalSheet(context, item!.id!);
      },

      child: getCard(),
    );
  }

  getCard() {
    return Container(
        height: height,
        width: width,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: yellowLight,
            borderRadius: new BorderRadius.all(const Radius.circular(15.0))
        ),

        child: Stack(
          children: [

            // photo
            Container(
              height: height,
              width: width,

              decoration: BoxDecoration(
                  color: yellowLight,
                  borderRadius: new BorderRadius.all(const Radius.circular(15.0))
              ),

              child: ClipRRect(
                borderRadius:  new BorderRadius.all(const Radius.circular(15.0)),
                child: getFirstImage(item!),
              )

            ),

            // positioned price
            Positioned(
                bottom: 0,
                right: 0,
                child: ItemPrice(
                  price: item!.price!,
                  height: 40,
                  width: (width! * 0.40),
                  margin: EdgeInsets.all(10),
                  fontSize: 19,
                )
            )
          ],
        )
    );
  }

  Image? getFirstImage(Item item) {
    if(item.photos.length <= 0) {
      return Image.asset(WANE_LOGO, fit: BoxFit.contain);
    } else {
      return Image.network(item.photos[0].url!, fit: BoxFit.contain);
    }
  }

  showItemModalSheet(context, int id) {
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
    );
  }

}