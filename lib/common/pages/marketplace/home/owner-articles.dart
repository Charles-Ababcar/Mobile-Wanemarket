import 'package:flutter/material.dart';
import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/bloc/article/article_bloc.dart';
import 'package:mobile_frontend/common/bloc/article/article_edit_bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/item_photo_info.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/material/round-button.dart';
import 'package:mobile_frontend/common/pages/item/items-description.dart';
import 'package:mobile_frontend/common/pages/marketplace/home/item_form_edit.dart';
import 'package:mobile_frontend/constraints.dart';

import 'item-card-owner.dart';
import 'item_form_new.dart';

class OwnerArticlesWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OwnerArticlesWidget();
  
}

/**
 * Page contenant les articles de l'annonceur
 */
class _OwnerArticlesWidget extends State<OwnerArticlesWidget> {

  @override
  void initState() {
    super.initState();
    ownerItemsBloc.loadOwnerArticles();
  }

  @override 
  void dispose() {
    super.dispose();
    // ownerItemsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    
    return Stack(
      children: [
        getContainer(size),
        getAddButton(),
      ],
    );
  }

  getContainer(Size size) {
    return Container (
        color: yellowLight,
        height: size.height,
        width: size.width,
        padding: EdgeInsets.only(left: 15, right: 15),

        child: StreamBuilder< List<Item>? > (
          stream: ownerItemsBloc.ownerArticlesStream,
          initialData: null,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

            if(snapshot.hasData || snapshot.data != null) {

              List< Item >? items = snapshot.data;

              return ListView(
                  scrollDirection: Axis.vertical,
                  children: items!.map<Widget> ((Item item) {

                    return ItemCardOwner(
                      item: item,

                      onClick: (int id) {
                        showItemModalSheet(context, id);
                      },

                      onEdit: (int itemId) {
                        this.showEditForm(itemId);
                      },

                      onLongPress: (int itemId) {
                        this.showDeleteButton(itemId);
                      },

                    );

                  }).toList()
              );

            } else {
              return LoadingIcon();
            }
          },
        )

    );
  }

  showEditForm(int itemId) {
    Navigator.push(context, new MaterialPageRoute(
        builder: (BuildContext context) {
          return ItemFormEdit(
            itemId: itemId,
            callback: (item, pictures) {

              // edit item
              return editItem(item, pictures);

            },
          );
          //return  NewItemForm();
        }
    ));
  }

  showDeleteButton(int itemId) {
    String title = "Supprimer l'annonce ?";
    String mess  = "Vous ne pourrez pas la retrouver";
    showDialog(context: context, builder: (context) => Popup.confirmDelete(context, title, mess, () async {
      bool isDeleted = await ownerItemsBloc.deleteArticle(itemId);
      ownerItemsBloc.loadOwnerArticles();
    }));
  }

  ///
  /// edit item
  ///
  editItem(Item item, List<ItemPhotoInfo> pictures) async {
    return articleEditBloc.update(item, pictures);
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
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(10)
            )
        ),

        builder: (context) => ItemDescription(itemId: id, isAdmin: false)
    );*/
  }

  getAddButton() {
    return Positioned(
      bottom: 10,
      right: 10,
      child: RoundButton(
        height: 50,
        width: 50,
        buttonColor: yellowStrong,
        icon: Icon(Icons.add, color: Colors.white, size: 20,),
        callback: () {
          Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) {
              return ItemFormNew(
                  callback: (item, pictures) {
                    addItem(item, pictures);
                  }
              );
            }
          ));
        },
      ),
    );
  }


  /**
   * bloc call
   */
  addItem(Item item, List<ItemPhotoInfo> pictures) {
    print("Add Item");
    int? marketplaceId = applicationState.authUser!.marketplace?.id;
    ownerItemsBloc.submit(marketplaceId, item, pictures);
  }

}