import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/article/article_category_bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/category.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/pages/home/item-card-category.dart';
import 'package:mobile_frontend/constraints.dart';

/**
 * Page to show X best items per categories
 * for the moment we just show the X last items (to be evolving)
 */
class CategoryPage extends StatefulWidget {

  // related category
  final Category? category;
  const CategoryPage({Key? key, this.category}): super(key: key);

  // limit of page
  final int limit = 200;

  @override
  State<StatefulWidget> createState() => _CategoryPage();

}

class _CategoryPage extends State<CategoryPage> {

  // laod items by category and limit
  ArticleCategoryBloc bloc = new ArticleCategoryBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // load categories
    bloc.findLatestItemsByCategoryId(widget.category!.id!, widget.limit);
  }

  // destroy
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // destroy bloc
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

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
      body: StreamBuilder< List<Item>? >(
        stream: bloc.stream,
        initialData: null,
        builder: (context, snapshot) {

          // loading icon while loading
          if(snapshot.data == null || !snapshot.hasData) {

            return Center(
                child: LoadingIcon()
            );

          } else {

            List<Item>? items = snapshot.data;

            return ListView(
                scrollDirection: Axis.vertical,
                children: items!.map<Widget> ((Item item) {
                  return ItemCardCategory(
                      item: item,
                      height: 250,
                      width: size.width,

                  );
                }).toList()
            );

          }
        },
      ),

    );

  }
}