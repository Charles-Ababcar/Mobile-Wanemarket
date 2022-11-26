import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/article/article_favorite_bloc.dart';
import 'package:mobile_frontend/common/bloc/article/article_lekket_action.dart';
import 'package:mobile_frontend/common/bloc/article/purchase_list_bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/purchase_order.dart';
import 'package:mobile_frontend/common/material/empty-wave.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/pages/lekket/item-card-lekket.dart';
import 'package:mobile_frontend/common/pages/search/item-card-full.dart';
import 'package:mobile_frontend/constraints.dart';


class FavoritePage extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => _FavoritePage();

}

class _FavoritePage extends State<FavoritePage> {

  @override
  void initState() {
    super.initState();
    wishListBloc.loadWishList();
  }

  @override
  void dispose() {
    super.dispose();
    // lekketBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

  Size size = MediaQuery.of(context).size;

   return Container(
   
    height: size.height,
    width: size.width,

    child: StreamBuilder< List<Item>? > (
      stream: wishListBloc.wishListStream,
      initialData: null,
      builder: (context, snapshot) {

        if(snapshot.hasData || snapshot.data != null) {
          if(snapshot.data!.length == 0) {
            return EmptyWave(
              text: "Vous n'avez aucun favori",
              icon: Icons.favorite,
            );
          } else {
            return getListView(snapshot.data!);
          }
        } else {
          return LoadingIcon();
        }

      },
    ),
   );

  }

  ListView getListView(List<Item> items) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: items.map<Widget> ((Item item) {
        return ItemCardReseach(item);
      }).toList()
    );
  }

}