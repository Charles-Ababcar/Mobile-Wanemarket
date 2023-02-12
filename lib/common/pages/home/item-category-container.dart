import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/article/article_category_bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/category.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/pages/home/category-full-list.dart';
// consts
import 'package:mobile_frontend/constraints.dart';

import 'item-card.dart';

class ItemContainer extends StatefulWidget {

  late Category category;

  int limit = 20;

  ItemContainer(Category category) {
    this.category = category;
  }

  @override
  _ItemContainer createState() => _ItemContainer();
}

/**
 * CLASS WHO CONTAINS A LIST OF ITEM
 * BY CATEGORY
 */
class _ItemContainer extends State<ItemContainer> {

  ArticleCategoryBloc bloc = new ArticleCategoryBloc();

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      bloc.findLatestItemsByCategoryId(widget.category.id!, widget.limit);
  }

  @override
  void dispose() {
      // TODO: implement dispose
      super.dispose();
      bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Container(
      height: 300,
      width: size.width,
      color: yellowLight,
      margin: EdgeInsets.only(bottom: 10),

      child: Column(
        children: [
          /**
           * TITLE OF CATEGORY
           */
          title(),

          /**
           * ARTICLES RELATED TO THAT CATEGORY
           */
          itemList()
        ]
      ),
    );
  }

  Widget title() {
    return GestureDetector(

      // for more
      onTap: () {
        Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) {
              return CategoryPage(category: widget.category);
            }
        ));
      },

      child: Container(
        height: 50,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(
          // top: 10,
            bottom: 20
        ),
        decoration: BoxDecoration(
            color: yellowSemi,
            /*
        border: Border(
          bottom: BorderSide(width: 1.0, color: borderColor),
        ),*/
            borderRadius: new BorderRadius.all( const Radius.circular(15.0))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 20,),
            Center(child: Text(this.widget.category.title!)),

            Icon(Icons.arrow_forward_ios , size: 20,),

          ],
        ),
      ),
    );
  }

  Widget itemList() {

    const Color borderColor = yellowStrong;
    const Color fillColor = yellowLight;

    return StreamBuilder< List<Item>? >(
      stream: bloc.stream,
      initialData: null,
      builder: (context, snapshot) {

        if(snapshot.data == null || !snapshot.hasData) {

          return Container(
            color: yellowSemi,
          );
          // return Center(
          //   child: LoadingIcon()
          // );

        } else {

          List<Item>? items = snapshot.data;

          return Container(
            height: 220,
            color: fillColor,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: items!.map<Widget> ((item) {
                return new ItemCardHome(item);
              }).toList()
            ),
          );
        }
      },
    );    
  }

}