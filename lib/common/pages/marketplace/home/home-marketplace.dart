import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/pages/marketplace/home/ordered-items/ordered-item-list.dart';
import 'package:mobile_frontend/common/pages/marketplace/home/owner-articles.dart';
import 'package:mobile_frontend/common/pages/marketplace/home/returned_items/returned_items_infos.dart';
import 'package:mobile_frontend/common/pages/marketplace/home/returned_items/returned_items_list.dart';
import 'package:mobile_frontend/constraints.dart';

class MarketPlace extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MarketPlace();
}

class _MarketPlace extends State<MarketPlace> {

  /**
   * owner items
   */
  final OwnerArticlesWidget ownerArticles   = new OwnerArticlesWidget();
  final OrderedItemList orderedItemList     = new OrderedItemList();
  final ReturnedItemsList returnedItemsList = new ReturnedItemsList();

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: 3,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: yellowLight,

            appBar: AppBar(
              backgroundColor: yellowStrong,
              bottom: TabBar(
                indicatorColor: yellowSemi,
                tabs: [
                  Tab(text: "Annonces"),
                  Tab(text: "Ventes"),
                  Tab(text: "Retour"),
                ],
              ),
              title: Center(child: Text("Espace annonceur"),),
            ),

            // body
            body: TabBarView(

              children: [
                Padding(
                    padding: EdgeInsets.only(top: 20),
                  child: ownerArticles
                ),

                Padding(
                    padding: EdgeInsets.all(20),
                    child: orderedItemList,

                ),

                Padding(
                  padding: EdgeInsets.all(20),
                  child: returnedItemsList,
                ),

                // Container(),
              ],
            ),

        ),
    );
  }

}