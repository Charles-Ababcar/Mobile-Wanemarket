import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/bloc/user_data_bloc.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-scrollable.dart';
import 'package:mobile_frontend/common/material/action-button.dart';
import 'package:mobile_frontend/common/material/item-card/label-item.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/pages/auth/edit_profile.dart';
import 'package:mobile_frontend/common/pages/marketplace/create-marketplace-form.dart';
import 'package:mobile_frontend/common/pages/marketplace/home/home-marketplace.dart';
import 'package:mobile_frontend/common/pages/monitoring/home-monitoring.dart';
import 'package:mobile_frontend/common/pages/orders/order_list.dart';
import 'package:mobile_frontend/common/pages/solde/solde_page.dart';
//import 'package:open_whatsapp/open_whatsapp.dart';

// colors
import 'package:mobile_frontend/constraints.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountSettingsPage();
}

class _AccountSettingsPage extends State<AccountSettingsPage> {
  String _platformVersion = 'Unknown';
/*
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterOpenWhatsapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }
*/
  @override
  void initState() {
    super.initState();
    //initPlatformState();
    userDataBloc.loadUserFromRemote();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        height: size.height,
        width: size.width,
        child: StreamBuilder<User?>(
          stream: userDataBloc.userStream,
          initialData: applicationState.authUser,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return LoadingIcon();
            } else {
              return CustomScrollable(
                child: mainPage(snapshot.data!, size),
              );
            }
          },
        ));
  }

  ////////////////////////////////
  ////////// MAIN PAGE   /////////
  ////////////////////////////////

  Widget mainPage(User user, Size size) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      /**
           * profile card
           */
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (BuildContext context) {
            return new EditProfilePage();
          }));
        },
        child: profileCard(user, size),
      ),
      SizedBox(height: sizedBoxHeight),

      /**
           * marketplace card
           */
      (hasMarketplace(user) /*&& isMarketplaceValidated(user)*/ ? marketplaceCard(
              user, size)
          : new Container()),
      SizedBox(height: 10),

      /**
           * s'il a des roles, on affiche le bouton
           * des rôles
           */
      (hasRoles() ? adminSpaceButton(context) : new Container()),

      /**
           * s'il a déjà un marketplace
           * oon affiche pas le button
           */
      (!hasMarketplace(user)
          ? marketplaceRequestButton(context)
          : new Container()),

      /**
           * s'il a déjà un marketplace
           * oon affiche pas le button
           */
      (hasMarketplace(user) ? sellerSpaceButton(context) : new Container()),
      (hasMarketplace(user) ? moneyAcountButton(context) : new Container()),

      /**
           * edit profile button
           */
      ordersLiqtButton(context),
      whatsAppButton(context),
      ActionButton(
        icon: Icon(Icons.power_off_rounded, color: Colors.black, size: 30),
        iconBackgroundColor: Color(0xFFffdede),
        mainColor: Color(0xFFffdede),
        borderColor: Color(0xFFffdede),
        text: Text("Déconnexion", style: TextStyle(fontSize: 15)),
        callback: () {
          showDialog(
              context: context,
              builder: (context) =>
                  Popup.confirmDeconnection(context, "Message"));
        },
      ),
    ]);
  }

  ////////////////////////////////
  //////// SUB COMPONENTS   //////
  ////////////////////////////////

  ActionButton ordersLiqtButton(BuildContext context) {
    return ActionButton(
      icon: Icon(Icons.history, color: yellowSemi, size: 30),
      borderColor: yellowSemi,
      text: Text("Mes commandes", style: TextStyle(fontSize: 15)),
      callback: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return OrderList();
        }));
      },
    );
  }

  ActionButton marketplaceRequestButton(BuildContext context) {
    return ActionButton(
      icon: Icon(Icons.business_center, color: yellowSemi, size: 30),
      borderColor: yellowSemi,
      text: Text("Professionnel ? Vendre ses articles ?",
          style: TextStyle(fontSize: 15)),
      callback: () => {
        // on push l'interface formulaire annonceur
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return new MarketPlaceFormWidget();
        }))
      },
    );
  }

  ActionButton sellerSpaceButton(BuildContext context) {
    return ActionButton(
      icon: Icon(Icons.business_center, color: Color(0xFFffdede), size: 30),
      iconBackgroundColor: yellowLight,
      mainColor: yellowLight,
      borderColor: Color(0xFFffdede),
      text: Text("Espace annonceur", style: TextStyle(fontSize: 15)),
      // push interface annonceur
      callback: () => {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return new MarketPlace();
        }))
      },
    );
  }

  ActionButton moneyAcountButton(BuildContext context) {
    return ActionButton(
      icon: Icon(Icons.attach_money, color: Color(0xFFd3f0d0), size: 30),
      iconBackgroundColor: yellowLight,
      mainColor: yellowLight,
      borderColor: Color(0xFFd3f0d0),
      text: Text("Solde annonceur", style: TextStyle(fontSize: 15)),
      // push interface annonceur
      callback: () => {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return new SoldePage();
          ;
        }))
      },
    );
  }

  ActionButton adminSpaceButton(BuildContext context) {
    return ActionButton(
        icon: Icon(Icons.monitor, color: yellowSemi, size: 30),
        iconBackgroundColor: yellowLight,
        mainColor: yellowLight,
        borderColor: yellowSemi, //Color(0xFFc2e9fb),
        text: Text("Administrateurs", style: TextStyle(fontSize: 15)),
        callback: () => {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (BuildContext context) {
                return new HomeMonitoringWidget();
              }))
            });
  }

  ActionButton whatsAppButton(BuildContext context) {
    return ActionButton(
        icon: Icon(Icons.contact_mail, color: Colors.white, size: 30),
        iconBackgroundColor: lightGreen,
        mainColor: lightGreen,
        borderColor: lightGreen, //Color(0xFFc2e9fb),
        text: Text("WhatsApp (Contact)", style: TextStyle(fontSize: 15)),
        callback: () {
          //  FlutterOpenWhatsapp.sendSingleMessage("+221763453362",
          //      "Bonjour Wanémarket, Je vous contacte depuis l'application mobile afin de ...");
          OpenWhatsapp();
        });
  }

//////////////////OpenWhatsap
  // ignore: non_constant_identifier_names
  OpenWhatsapp() async {
    var whatsapp = "+33647101319";
    // var whatsappURLAndroid =
    //     "whatsapp://wa.me/$whatsapp/?text=${Uri.parse("Bonjour Wanémarket, Je vous contacte depuis l'application mobile afin de ...")}";
    var whatsappURLAndroid = "whatsapp://send?phone=" +
        whatsapp +
        "&text=Bonjour Wanémarket, Je vous contacte depuis l'application mobile afin de ...";

    var whatsappURLIos =
        "https://wa.me/$whatsapp?text=${Uri.parse("Bonjour Wanémarket, Je vous contacte depuis l'application mobile afin de ...")}";
    if (Platform.isIOS) {
      //pour téléphone IOS uniquement
      // ignore: deprecated_member_use
      if (await canLaunch(whatsappURLIos)) {
        // ignore: deprecated_member_use
        await launch(whatsappURLIos, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("WhatsApp non installé")));
      }
    } else {
      //pour téléphone android, web
      // ignore: deprecated_member_use
      if (await canLaunch(whatsappURLAndroid)) {
        // ignore: deprecated_member_use
        await launch(whatsappURLAndroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("WhatsApp non installé")));
      }
    }
  }

/////////////////////

  Widget profileCard(User user, Size size) {
    return Container(
        height: 150,
        width: size.width * 0.9,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFd3f0d0),
          borderRadius: new BorderRadius.all(
            Radius.circular(15.0),
          ),
          border: Border(
            top: BorderSide(width: 3.0, color: Color(0xFFd3f0d0)),
            left: BorderSide(width: 3.0, color: Color(0xFFd3f0d0)),
            right: BorderSide(width: 3.0, color: Color(0xFFd3f0d0)),
            bottom: BorderSide(width: 3.0, color: Color(0xFFd3f0d0)),
          ),
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Container(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
                "${user.firstName!.toUpperCase()} ${user.lastName!.toUpperCase()}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black)),
          ),
          Text(
              "Inscrit le : ${user.creationDate!.day} ${getMonthByNumber(user.creationDate!.month)} ${user.creationDate!.year}"),
          LabelItem(
              icon: Icon(Icons.perm_identity, size: 22),
              fontSize: 14,
              text: "N° de compte: ${user.id.toString()}"),
          LabelItem(
              icon: Icon(Icons.phone, size: 22),
              fontSize: 14,
              text: user.phone),
          LabelItem(
              icon: Icon(Icons.location_city, size: 22),
              fontSize: 14,
              text: "${user.city!.title} (${user.address})"),
        ]));
  }

  Widget marketplaceCard(User user, Size size) {
    return Container(
        height: 180,
        width: size.width * 0.9,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(
            Radius.circular(15.0),
          ),
          color: yellowSemi,
          border: Border(
            top: BorderSide(width: 3.0, color: yellowSemi),
            left: BorderSide(width: 3.0, color: yellowSemi),
            right: BorderSide(width: 3.0, color: yellowSemi),
            bottom: BorderSide(width: 3.0, color: yellowSemi),
          ),
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Container(
            padding: EdgeInsets.only(bottom: 5),
            child: Text("${user.marketplace!.name!.toUpperCase()}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          Text(
              "Depuis le : ${user.marketplace!.creationDate!.day} ${getMonthByNumber(user.marketplace!.creationDate!.month)} ${user.marketplace?.creationDate?.year}"),

          LabelItem(
              icon: Icon(Icons.perm_identity, size: 22),
              fontSize: 14,
              text: "Identifiant: ${user.marketplace!.id}"),

          LabelItem(
              icon: Icon(Icons.location_city, size: 22),
              fontSize: 14,
              text:
                  "${user.marketplace?.location?.title} (${user.marketplace?.address})"),

          // nombre articles vendus
          LabelItem(
              icon: Icon(Icons.business_center, size: 22),
              fontSize: 14,
              text: "Articles crées: ${user.itemCount}"),

          // nombre demandes
          LabelItem(
              icon: Icon(Icons.shopping_cart, size: 22),
              fontSize: 14,
              text: "Dernières ventes: ${user.soldItemsCount}"),
        ]));
  }

  ////////////////////////////////
  ///////////// LOGIC  ///////////
  ////////////////////////////////

  bool hasMarketplace(User? user) {
    if (user!.marketplace == null) return false;
    return true;

    // if (user.marketplaces != null && user.marketplaces!.length > 0) {
    //   return true;
    // }

    // return false;
  }

  bool isMarketplaceValidated(User user) {
    return user.marketplace != null && user.marketplace?.status == "VALIDATED";
  }

  bool hasRoles() {
    return applicationState.isMarketplaceMonitor() |
        applicationState.isAnnonceMonitor() |
        applicationState.isAdminMonitor();
  }

  String getMonthByNumber(int number) {
    if (number == 1) return "Janvier";
    if (number == 2) return "Février";
    if (number == 3) return "Mars";
    if (number == 4) return "Avril";
    if (number == 5) return "Mai";
    if (number == 6) return "Juin";
    if (number == 7) return "Juillet";
    if (number == 8) return "Août";
    if (number == 9) return "Septembre";
    if (number == 10) return "Octobre";
    if (number == 11) return "Novembre";
    if (number == 12) return "Décembre";
    return "";
  }
}
