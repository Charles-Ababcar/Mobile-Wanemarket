import 'package:flutter/material.dart';
import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/bloc/categories_bloc.dart';
import 'package:mobile_frontend/common/classes/category.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-scrollable.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/material/round-button.dart';
import 'package:mobile_frontend/common/pages/account_settings/settings.dart';
import 'package:mobile_frontend/common/pages/auth/auth.dart';
import 'package:mobile_frontend/common/pages/favorite/favorite_page.dart';
import 'package:mobile_frontend/common/pages/home/category-full-list.dart';
import 'package:mobile_frontend/common/pages/home/home-visitor.dart';
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

class ScaffoldVisitorCustom extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScaffoldVisitorCustom();
}

class _ScaffoldVisitorCustom extends State<ScaffoldVisitorCustom> {
  late bool authView = false;
  Widget body = new HomePage();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final CategoriesBloc categoriesBloc = new CategoriesBloc();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        authView ? getAuthPage() : getAnnoncePage(size),
        Positioned(
          bottom: 20,
          right: 20,
          child: authView ? annonceButton() : authButton(),
        ),
      ],
    );
  }

  ///
  /// auth page / annonce page
  ///

  getAuthPage() {
    return Material(
      child: AuthPage(),
    );
  }

  getAnnoncePage(Size size) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: getDrawer2(),

      /**
       * APPBAR OF THE SCAFFOLD
       */
      appBar: AppBar(
        toolbarHeight: 60,
        leading: GestureDetector(
          onTap: () {
            categoriesBloc.loadAllCategories();
            _scaffoldKey.currentState!.openDrawer();
          },
          child: Icon(
            Icons.menu,
            color: yellowStrong,
          ),
        ),
        title: Image.asset("images/wanemarket_logo.png", height: 50),
        centerTitle: true,
        backgroundColor: yellowSemi,
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
        child: HomePageVisitor(),
      ),
    );
  }

  ///
  /// swutch button
  ///

  annonceButton() {
    return RoundButton(
      height: 50,
      width: 50,
      buttonColor: yellowStrong,
      icon: Icon(
        Icons.shopping_basket,
        color: Colors.white,
      ),
      callback: () {
        setState(() {
          authView = false;
        });
      },
    );
  }

  authButton() {
    return RoundButton(
      height: 50,
      width: 50,
      buttonColor: yellowStrong,
      icon: Icon(
        Icons.login,
        color: Colors.white,
      ),
      callback: () {
        setState(() {
          authView = true;
        });
      },
    );
  }

  ///
  /// drawer
  ///

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
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Les catégories',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                )
              ],
            ),
          ),
          StreamBuilder<List<Category>?>(
            stream: categoriesBloc.stream,
            initialData: null,
            builder: (context, snapshot) {
              if (snapshot.hasData || snapshot.data != null) {
                return ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: snapshot.data!.map<Widget>((Category cat) {
                    if (cat.title!.contains("Toutes les")) {
                      return SizedBox(
                        height: 0,
                      );
                    } else {
                      return ListTile(
                        title: Text(
                          '${cat.title}',
                          style: TextStyle(
                            color: Colors.brown,
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (BuildContext context) {
                            return CategoryPage(category: cat);
                          }));
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
        ],
      ),
    );
  }
}
