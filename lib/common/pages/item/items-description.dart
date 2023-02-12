import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/bloc/article/article_description_bloc.dart';
import 'package:mobile_frontend/common/bloc/article/article_lekket_action.dart';
import 'package:mobile_frontend/common/bloc/article/article_wishlist_bloc.dart';
import 'package:mobile_frontend/common/bloc/article/article_favorite_bloc.dart';
import 'package:mobile_frontend/common/bloc/article/purchase_list_bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/classes/price-format.dart';
import 'package:mobile_frontend/common/classes/string-cut.dart';
import 'package:mobile_frontend/common/customed-widgets/ConfirmLekketWidget.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-scrollable.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/material/item-card/label-item.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/constraints.dart';

/**
 * Widget which show complete description of an
 * item (price, title, photo, description, and deals with customers)
 */
class ItemDescription extends StatefulWidget {
  final int itemId;
  final bool isAdmin;
  final int? itemLekketId;

  const ItemDescription(
      {Key? key,
      required this.itemId,
      this.itemLekketId,
      required this.isAdmin})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemDescription();
}

class _ItemDescription extends State<ItemDescription> {
  int currentId = 0;
  Image? currentImage = null;
  bool hasAnyImage = false;

  ArticleDescriptionBloc bloc = new ArticleDescriptionBloc();
  ItemLekketActionBloc lekketActionBloc = new ItemLekketActionBloc();
  ItemWishListActionBloc itemWishListActionBloc = new ItemWishListActionBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.loadItem(widget.itemId, widget.isAdmin);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
    lekketActionBloc.dispose();
    itemWishListActionBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // return new Material(

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: yellowStrong,),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<Item?>(
        stream: bloc.itemStream,
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.data == null || !snapshot.hasData) {
            return LoadingIcon();
          } else {
            Item item = snapshot.data!;
            print("InLekket : ${item.inMyLekket}");
            print("InMyWidhList : ${item.inMyWidhList}");
            return mainDescriptionPage(size, item);
          }
        },
      ),
    );


    // );
  }

  Widget mainDescriptionPage(Size size, Item item) {
    return CustomScrollable(
      child: Column(children: [
        /**
         * Item's photo
         */
        SizedBox(height: 10,),
        photoContainer(size, item),

        /**
         * content of item
         */
        Padding(
          padding: EdgeInsets.only(right: 10, left: 10),
          child: descriptionContainer3(size, item),
        )
      ]
      ),
    );
  }

  Widget photoContainer(Size size, Item item) {
    return InkWell(
      child: Container(
        width: size.width,
        height: 400,
        color: yellowLight,
        child: currentImage != null ? currentImage : getFirstImage(item),
      ),
      onTap: () {
        if (hasAnyImage) {
          if (currentId + 1 < item.photos.length) {
            currentId += 1;
          } else {
            currentId = 0;
          }

          setState(() {
            currentImage =
                Image.network(item.photos[currentId].url!, fit: BoxFit.contain);
          });
        }
      },
      onLongPress: () {
        if (currentImage != null && hasAnyImage) {
          showDialog(
              context: context,
              builder: (context) {
                return Popup.showImageNetwork(item.photos[currentId].url!);
              });
        }
      },
    );
  }

  Widget descriptionContainer(Size size, Item item) {
    return Expanded(
      child: Container(
          padding: EdgeInsets.all(10),
          child: CustomScrollable(
            child: Column(children: [
              /**
               * title item
               */
              Container(
                height: 50,
                width: size.width,
                margin: EdgeInsets.only(bottom: 10),
                // child: Text("${item.title}", style: TextStyle (
                //     fontSize: 18,
                //     fontWeight: FontWeight.bold
                // )),
                child: Text("${item.title}",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 2),
                height: 50,
                width: size.width,
                child: Center(
                  child: Text("${PriceFormat.formatePrice(item.price!)}",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ),
                decoration: BoxDecoration(
                    color: yellowStrong,
                    borderRadius:
                        new BorderRadius.all(const Radius.circular(12.0))),
              ),

              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(width: 10, height: 5),
                applicationState.authToken == null
                    ? Container()
                    : ((item.inMyWidhList == true
                        ? favoriteButtonRemove()
                        : favoriteButtonAdd())),

                SizedBox(width: 10, height: 5),

                applicationState.authToken == null
                    ? Container()
                    : ((item.inMyLekket == true
                        ? lekketRemove()
                        : lekketAdd(item))),

                SizedBox(width: 10, height: 5),
                // applicationState.authToken != null

                redirectToAuthButton()
              ]),


            ]),
          )),
    );
  }

  Widget descriptionContainer3(Size size, Item item) {
    return Column(children: [

      /**
       * title item
       */
      Container(
        height: 50,
        width: size.width,
        margin: EdgeInsets.only(bottom: 10),
        // child: Text("${item.title}", style: TextStyle (
        //     fontSize: 18,
        //     fontWeight: FontWeight.bold
        // )),
        child: Text("${item.title}",
            style:
            TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),

      /**
       * price
       */
      Container(
        margin: EdgeInsets.only(bottom: 2),
        height: 50,
        width: size.width,
        child: Center(
          child: Text("${PriceFormat.formatePrice(item.price!)}",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w600)),
        ),
        decoration: BoxDecoration(
            color: yellowStrong,
            borderRadius:
            new BorderRadius.all(const Radius.circular(12.0))),
      ),

      SizedBox(width: 10, height: 5),

      applicationState.authToken == null
          ? Container()
          : ((item.inMyWidhList == true
          ? favoriteButtonRemove()
          : favoriteButtonAdd())),

      SizedBox(width: 10, height: 5),

      applicationState.authToken == null
          ? Container()
          : ((item.inMyLekket == true
          ? SizedBox(height: 0,)
          : lekketAdd(item))),

      SizedBox(width: 10, height: 5),
      // applicationState.authToken != null

      // redirectToAuthButton(),

      getRowInfo(Icons.person, "Boutique '${item.ownerName}'"),
      SizedBox(height: 10,),

      getRowInfo(Icons.location_city, "${item.ownerCity}"),
      SizedBox(height: 10,),

      getRowInfo(Icons.hourglass_top, "Ajoutée le ${item.creationDate!.toLocal().toString().split(' ')[0]}"),
      SizedBox(height: 10,),

      getRowInfo(Icons.category, "${StringWrapper.cut(item.category!.title!, 25)}"),
      SizedBox(height: 10,),

      getRowInfo(Icons.burst_mode, "${item.photos.length} photo(s) disponible(s)."),
      SizedBox(height: 10,),

      item.clothesSizedAvailable.length == 0 ? SizedBox(height: 0,) : getRowInfo(Icons.checkroom, "${item.clothesSizedAvailable.join(", ")}."),
      SizedBox(height: 10,),

      item.shoesSizeAvailable.length == 0 ? SizedBox(height: 0,) : getRowInfo(Icons.square_foot, "${item.shoesSizeAvailable.join(", ")}."),
      SizedBox(height: 10,),

      item.colorsAvailable.length == 0 ? SizedBox(height: 0,) : getRowInfo(Icons.color_lens, "${item.colorsAvailable.join(", ")}."),
      SizedBox(height: 10,),

      getDescription("${item.description}")

    ]);
  }

  Widget descriptionContainer2(Size size, Item item) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        child: CustomScrollable(
          child: Column(children: [

            /**
             * title item
             */
            Container(
              height: 50,
              width: size.width,
              margin: EdgeInsets.only(bottom: 10),
              // child: Text("${item.title}", style: TextStyle (
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold
              // )),
              child: Text("${item.title}",
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            /**
             * price
             */
            Container(
              margin: EdgeInsets.only(bottom: 2),
              height: 50,
              width: size.width,
              child: Center(
                child: Text("${PriceFormat.formatePrice(item.price!)}",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
              ),
              decoration: BoxDecoration(
                  color: yellowStrong,
                  borderRadius:
                  new BorderRadius.all(const Radius.circular(12.0))),
            ),

            SizedBox(width: 10, height: 5),

            applicationState.authToken == null
                ? Container()
                : ((item.inMyWidhList == true
                ? favoriteButtonRemove()
                : favoriteButtonAdd())),

            SizedBox(width: 10, height: 5),

            applicationState.authToken == null
                ? Container()
                : ((item.inMyLekket == true
                ? SizedBox(height: 0,)
                : lekketAdd(item))),

            SizedBox(width: 10, height: 5),
            // applicationState.authToken != null

            // redirectToAuthButton(),

            getRowInfo(Icons.person, "Boutique '${item.ownerName}'"),
            SizedBox(height: 10,),

            getRowInfo(Icons.location_city, "${item.ownerCity}"),
            SizedBox(height: 10,),

            getRowInfo(Icons.hourglass_top, "Ajoutée le ${item.creationDate!.toLocal().toString().split(' ')[0]}"),
            SizedBox(height: 10,),

            getRowInfo(Icons.category, "${StringWrapper.cut(item.category!.title!, 25)}"),
            SizedBox(height: 10,),

            getRowInfo(Icons.burst_mode, "${item.photos.length} photo(s) disponible(s)."),
            SizedBox(height: 10,),

            item.clothesSizedAvailable.length == 0 ? SizedBox(height: 0,) : getRowInfo(Icons.checkroom, "${item.clothesSizedAvailable.join(", ")}."),
            SizedBox(height: 10,),

            item.shoesSizeAvailable.length == 0 ? SizedBox(height: 0,) : getRowInfo(Icons.square_foot, "${item.shoesSizeAvailable.join(", ")}."),
            SizedBox(height: 10,),

            item.colorsAvailable.length == 0 ? SizedBox(height: 0,) : getRowInfo(Icons.color_lens, "${item.colorsAvailable.join(", ")}."),
            SizedBox(height: 10,),

            getDescription("${item.description}")

          ]),
        )),
    );
  }

  getDescription(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),)
    );
  }

  getRowInfo(IconData iconData, String text) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          child: Center(child: Icon(iconData, size: 30,),),

          decoration: BoxDecoration(
              color: yellowSemi,
              // color: yellowSemi,
              borderRadius : new BorderRadius.all(const Radius.circular(30.0))
          ),
        ),

        SizedBox(width: 20,),

        Container(
          child: Text(text, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),),
        )
      ],
    );
  }

  redirectToAuthButton() {
    return applicationState.authToken == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BigButton(
                icon: Icon(Icons.shopping_basket),
                background: yellowSemi,
                text: Text(
                  " Connectez-vous pour acheter",
                  style: TextStyle(fontSize: 15),
                ),
                callback: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                },
              ),
              SizedBox(width: 20),
            ],
          )
        : Container();
  }

  lekketAdd(Item item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BigButton(
          icon: Icon(Icons.add),
          background: yellowSemi,
          text: Text(
            "Panier",
            style: TextStyle(fontSize: 20),
          ),
          callback: () {
            showDialog(context: context, builder: (BuildContext ctx) {
              return AlertDialog(
                title: Text('Ajouter au panier'),
                content:  ConfirmLekketWidget(
                    item: item,
                    callback: (int quantity, String shoeSize, String clotheSize, String color, String? instructions) async {
                      await lekketActionBloc.addItem(widget.itemId, quantity, shoeSize, clotheSize, color, instructions);
                      bloc.loadItem(widget.itemId, widget.isAdmin);
                      afterLekketAction();
                    }),
              );
            });/*
            Popup.modal(context, ConfirmLekketWidget(
              item: item,
              callback: (int quantity, String shoeSize, String clotheSize, String color, String? instructions) async {
                await lekketActionBloc.addItem(widget.itemId, quantity, shoeSize, clotheSize, color, instructions);
                bloc.loadItem(widget.itemId, widget.isAdmin);
                afterLekketAction();
              })
            );*/
          },
        ),
        SizedBox(width: 20),
      ],
    );
  }

  lekketRemove() {
    return BigButton(
      icon: Icon(Icons.remove),
      background: yellowSemi,
      text: Text(
        "Panier",
        style: TextStyle(fontSize: 20),
      ),
      callback: () {
        showDialog(
          context: context,
          builder: (context) => Popup.confirmRemoveLekket(context, () async {
            await lekketActionBloc.removeItem(widget.itemLekketId!);
            bloc.loadItem(widget.itemId, widget.isAdmin);

            // doing some actions after removing from lekket
            afterLekketAction();
          }));
      },
    );
  }

  favoriteButtonAdd() {
    return BigButton(
      icon: Icon(Icons.favorite_border),
      background: lightPink,
      text: Text(
        "Favori",
        style: TextStyle(fontSize: 20),
      ),
      callback: () {
        showDialog(
            context: context,
            builder: (context) => Popup.confirmAddWishList(context, () async {
              // remove to favorite
              print("Adding to wushkusg");
              await itemWishListActionBloc.addWishLish(widget.itemId);
              print("load item ?");
              bloc.loadItem(widget.itemId, widget.isAdmin);

              // doing some actions after adding to favorite
              afterWishListAction();
            }));
      },
    );
  }

  favoriteButtonRemove() {
    return BigButton(
      icon: Icon(Icons.favorite),
      background: lightPink,
      text: Text(
        "Favori",
        style: TextStyle(fontSize: 20),
      ),
      callback: () {
        showDialog(
          context: context,
          builder: (context) =>
            Popup.confirmRemoveWishList(context, () async {
              // remove from favorite
              await itemWishListActionBloc.removeWishLish(widget.itemId);
              bloc.loadItem(widget.itemId, widget.isAdmin);

              // doing some actions after removing from favorite
              afterWishListAction();
            }));
      },
    );
  }

  afterLekketAction() {
    lekketListBloc.loadUserLekket();
  }

  afterWishListAction() {
    wishListBloc.loadWishList();
  }

  Image? getFirstImage(Item item) {
    if (item.photos.length <= 0) {
      return Image.asset(WANE_LOGO, fit: BoxFit.contain);
    } else {
      hasAnyImage = true;
      currentImage = Image.network(item.photos[0].url!, fit: BoxFit.contain);
      return currentImage;
    }
  }
}