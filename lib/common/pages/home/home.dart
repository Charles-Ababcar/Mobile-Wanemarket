import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/categories_bloc.dart';
import 'package:mobile_frontend/common/classes/category.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';

import 'item-category-container.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  CategoriesBloc bloc = new CategoriesBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.loadAllCategories();
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

    return new Container(
        height: size.height,
        width: size.width,
        child: Column(children: <Widget>[
          /**
           * who contains articles classified by categories
           */
          StreamBuilder<List<Category>?>(
            stream: bloc.stream,
            initialData: null,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return LoadingIcon();
              } else {
                return getCategoriesWidget(snapshot.data!);
              }
            },
          )
        ]));
  }

  /**
   * all categories containing lastest items 
   */
  Widget getCategoriesWidget(List<Category> categories) {
    categories = categories.sublist(1, categories.length);

    return Expanded(
      child: ListView(
          scrollDirection: Axis.vertical,
          children: categories.map<Widget>((category) {
            return ItemContainer(category);
          }).toList()),
    );
  }
}
