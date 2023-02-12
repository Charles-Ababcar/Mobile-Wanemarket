import 'package:flutter/material.dart';
import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/bloc/categories_bloc.dart';
import 'package:mobile_frontend/common/classes/category.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-scrollable.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/pages/account_settings/settings.dart';
import 'package:mobile_frontend/common/pages/favorite/favorite_page.dart';
import 'package:mobile_frontend/common/pages/home/category-full-list.dart';
import 'package:mobile_frontend/common/pages/home/home.dart';
import 'package:mobile_frontend/common/pages/information/welcoming.dart';
import 'package:mobile_frontend/common/pages/lekket/lekket.dart';
import 'package:mobile_frontend/common/pages/auth/login.dart';
import 'package:mobile_frontend/common/pages/auth/signup.dart';
import 'package:mobile_frontend/common/pages/search/search-list.dart';

// consts
import 'package:mobile_frontend/constraints.dart';

/**
 * THIS CLASS IS THE SCENE OF THE APP (SEARCH, HOME, PROFILE)
 */

class ScaffoldConnectedCustom extends StatefulWidget {
  @override
  _ScaffoldConnectedCustom createState() => _ScaffoldConnectedCustom();
}

class _ScaffoldConnectedCustom extends State<ScaffoldConnectedCustom> {
  
  late int currentIndex;
  Widget body = new HomePage();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final CategoriesBloc categoriesBloc = new CategoriesBloc();

  List<Category> categories = [
    Category(1, "Cat 1"),
    Category(1, "Cat 2"),
    Category(1, "Cat 3"),
  ];

  @override  
  initState() {
    super.initState();
    currentIndex = 0;
  }

  /**
   * change page by bottom navigation item 
   * tapped on app
   */
  changePageConnected(int index) {
    setState(() {
      currentIndex = index; 

      switch(index) {
        case 0:
          body  = new HomePage();
          break;
        case 1:
          body  = new ResearchPage();
          break;
        case 2:
          body  = new LekketPage();
          break;
        case 3:
          body  = new FavoritePage();
          break;
        case 4:
          body  = new AccountSettingsPage();
          break;
        default: 
          body = new HomePage();
          break;
      }
    });
  }

  changePageVisitor(int index) {
    setState(() {
      currentIndex = index;

      switch(index) {
        case 0:
          body  = new HomePage();
          break;
        case 1:
          body  = new ResearchPage();
          break;
      }
    });
  }

  void showLekketPage() {
    setState(() {
      body = new LekketPage();
    });
  }

  void showFavoritePage() {
    setState(() {
      body = new FavoritePage(); 
    });
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      drawer: getDrawer2(),

      /**
       * APPBAR OF THE SCAFFOLD
       */
      appBar: AppBar (
        toolbarHeight: 60,

        leading: GestureDetector(
          onTap: () {
            categoriesBloc.loadAllCategories();
            _scaffoldKey.currentState!.openDrawer();
          },
          child: Icon(Icons.menu, color: yellowStrong,),
        ),

        title: Image.asset("images/wanemarket_logo.png", height: 50),
        centerTitle: true,
        backgroundColor: yellowSemi,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Container(
            color: yellowStrong,
            height: 2.0
          ),
        ),

        // remove back button on left
        // automaticallyImplyLeading: false,
      ),

      backgroundColor: yellowLight,
      
      /**
       * MOVABLE BODY OF THE SCAFFOLD
       * Habillement de la partie centrale (paddings .. centrage)
       */
      body: Container(
        margin: const EdgeInsets.all(10.0),
        width: size.width,
        height: size.height,
        /**
         * body dynamically changed
         */
        child: body,  
      ),

      bottomNavigationBar: applicationState.authToken != null ? getBottomBarConnected(): getBottomBarVisitor()
    );
  }

  // getDrawer() {
  //   return Drawer(
  //     // Add a ListView to the drawer. This ensures the user can scroll
  //     // through the options in the drawer if there isn't enough vertical
  //     // space to fit everything.
  //     child: ListView(
  //       // Important: Remove any padding from the ListView.
  //       padding: EdgeInsets.zero,
  //       children: [
  //         DrawerHeader(
  //           decoration: BoxDecoration(
  //             color: yellowSemi,
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Image.asset("images/wanemarket_logo.png", height: 70),
  //               SizedBox(height: 5,),
  //               Text('Les catégories', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),)
  //             ],
  //           ),
  //         ),
  //
  //         StreamBuilder<List<Category>?>(
  //           stream: categoriesBloc.stream,
  //           initialData: null,
  //           builder: (context, snapshot) {
  //             if(snapshot.hasData || snapshot.data != null) {
  //               return Expanded(
  //                 child: ListView(
  //                   scrollDirection: Axis.horizontal,
  //                   children: snapshot.data!.map<Widget> ((Category cat) {
  //                     return ListTile(
  //                       title: Text('fff ${cat.title}'),
  //                       onTap: () {
  //                         // Update the state of the app
  //                         // ...
  //                         // Then close the drawer
  //                         Navigator.pop(context);
  //                       },
  //                     );
  //                   }).toList(),
  //               )
  //               );
  //             } else {
  //               return LoadingIcon();
  //               // return SizedBox(height: 0,);
  //             }
  //           },
  //         )
  //
  //       ],
  //     ),
  //   );
  // }

  getDrawer2() {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [

          DrawerHeader(
            decoration: BoxDecoration(
              color: yellowSemi,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/wanemarket_logo.png", height: 70),
                SizedBox(height: 5,),
                Text('Les catégories', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),)
              ],
            ),
          ),

          StreamBuilder<List<Category>?>(
            stream: categoriesBloc.stream,
            initialData: null,
            builder: (context, snapshot) {
              if(snapshot.hasData || snapshot.data != null) {
                return ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: snapshot.data!.map<Widget> ((Category cat) {
                    if(cat.title!.contains("Toutes les")) {
                      return SizedBox(height: 0,);
                    } else {
                      return ListTile(
                        title: Text('${cat.title}', style: TextStyle(
                          color: Colors.brown,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),),
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (BuildContext context) {
                                return CategoryPage(category: cat);
                              }
                          ));
                        },
                      );
                    }
                  }).toList(),
                );
              } else {
                return LoadingIcon();
                // return SizedBox(height: 0,);
              }
            },
          )

          // ListView(
          //   shrinkWrap: true,
          //   physics: ClampingScrollPhysics(),
          //   scrollDirection: Axis.vertical,
          //   children: categories.map<Widget> ((Category cat) {
          //     return ListTile(
          //       title: Text('fff ${cat.title}'),
          //       onTap: () {
          //         // Update the state of the app
          //         // ...
          //         // Then close the drawer
          //         Navigator.pop(context);
          //       },
          //     );
          //   }).toList(),
          // )

        ],
      ),
    );
  }


  getBottomBarConnected() {
    return BottomNavigationBar(
      backgroundColor: yellowLight,//Colors.white,
      currentIndex: currentIndex,
      onTap: changePageConnected ,
      selectedItemColor: yellowStrong,
      items: <BottomNavigationBarItem> [
        BottomNavigationBarItem(
            icon: Icon(Icons.home, color: yellowStrong),
            backgroundColor: yellowLight,
            label: "Home"
        ),

        BottomNavigationBarItem(
            icon: Icon(Icons.search, color: yellowStrong),
            backgroundColor: yellowLight,
            label: "Recherche",
        ),

        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket, color: yellowStrong),
            backgroundColor: yellowLight,
            label: "Lekket",
        ),

        BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: yellowStrong),
            backgroundColor: yellowLight,
            label: "Favoris"
        ),

        BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle, color: yellowStrong),
            backgroundColor: yellowLight,
            label: "Compte"
        ),
      ],
    );
  }

  getBottomBarVisitor() {
    return BottomNavigationBar(
      backgroundColor: yellowLight,//Colors.white,
      currentIndex: 0,
      onTap: changePageVisitor ,
      items: <BottomNavigationBarItem> [
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket, color: yellowStrong),
            backgroundColor: yellowLight,
            label: "Annonces"
        ),

        BottomNavigationBarItem(
            icon: Icon(Icons.search, color: yellowStrong),
            backgroundColor: yellowLight,
            label: "Recherche"
        ),
      ],
    );
  }

}