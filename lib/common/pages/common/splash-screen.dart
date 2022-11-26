import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-connected-scaffold.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/pages/home/home.dart';
import 'package:mobile_frontend/common/pages/auth/auth.dart';
import 'package:mobile_frontend/common/pages/auth/login.dart';

// colors
import 'package:mobile_frontend/constraints.dart';

// spin kit
import 'package:flutter_spinkit/flutter_spinkit.dart';

// components
import 'package:mobile_frontend/common/customed-widgets/custom-scaffold.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return new ScaffoldCustom(
        body: Container(
      color: Colors.white10,
      width: size.width * 0.80,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("images/wanemarket_logo.png", height: size.height * 0.10),

          SizedBox(height: 50),
          // SpinKitRipple(color: yellowStrong, size: 30),
          // SizedBox(height: 10),

          BigButton(
            text: Text("Voir les annonces"),
            background: yellowSemi,
            icon: Icon(Icons.shopping_basket),
            callback: () {
              // push limited home page
              Navigator.of(context).push(
                //.pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => ScaffoldConnectedCustom()),
                // (Route<dynamic> route) => false
              );
            },
          ),

          BigButton(
            text: Text("Se connecter"),
            background: yellowSemi,
            icon: Icon(Icons.lock),
            callback: () {
              Navigator.of(context).push(
                //.pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Material(
                          child: AuthPage(),
                        )),
                // (Route<dynamic> route) => false
              );
            },
          ),
        ],
      ),
    ));
  }
}
