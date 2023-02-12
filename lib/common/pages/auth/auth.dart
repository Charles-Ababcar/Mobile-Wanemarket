import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-scrollable.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/material/round-button.dart';
import 'package:mobile_frontend/common/pages/auth/login.dart';
import 'package:mobile_frontend/common/pages/auth/signup.dart';
import 'package:mobile_frontend/constraints.dart';

class AuthPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AuthPage();

}

class _AuthPage extends State<AuthPage> {

  bool isLoginMode = true;
  Widget loginWidget  = new LoginWidget();
  Widget signupWidget = new SignupWidget();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      color: yellowLight,
      padding: EdgeInsets.only(top: 50, right: 10, left: 10),

      child: Column(children: [


        Expanded (
          flex: 9,
          child: 
          
          isLoginMode 
          ? Center(
              child: CustomScrollable(
                child: LoginWidget() 
              )
            )

          : CustomScrollable(
              child: SignupWidget()
            )

        ),

        Expanded (
          flex: 1,
          child: Container(

            child: Row(

              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
            
                isLoginMode
                  ? new Container()
                  : RoundButton(
                    buttonColor: yellowSemi,
                    icon: Icon(Icons.arrow_back, size: 14,),
                    width: 40,
                    height: 40,
                    callback: () {
                      setState(() {
                        isLoginMode = true;
                      });
                   },           
                ),

                !isLoginMode
                  ? new Container()
                  :  signupButton(),
/*
                isLoginMode
                  ? new Container()
                  :  RoundButton(
                      buttonColor: yellowSemi,
                      icon: Icon(Icons.lock, size: 14,),
                      width: 40,
                      height: 40,
                      callback: () {
                        
                      },
                    )
*/
            ],),

          ),
        ),

      ],)

    );
  }

  signupButton() {
    return Container(
      width: 200,
      child: BigButton(
        icon: Icon(Icons.add, size: 15, color: Colors.white,),
        background: yellowStrong,
        text: Text("Créer un compte", style: TextStyle(
          color: Colors.white,
        ),),
        callback: () {
          setState(() {
            isLoginMode = false;
          });
        },
      ),
    );
  }
}