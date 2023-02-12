import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/constraints.dart';

/*
class MainButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainButtonStyle();
}
*/
class MainButton/*Style*/ extends StatelessWidget /*State<MainButton>*/ {

  bool isPressed = false;
  String? buttonText = "";
  Color buttonColor;
  Color textColor;
  final VoidCallback? onPressed;

  MainButton({this.buttonText, this.onPressed, this.buttonColor = yellowStrong, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: 60,
      width: size.width * 0.6,
      child: BigButton(
        background: buttonColor,
        icon: Icon(Icons.check, color: textColor,),
        text: Text(buttonText!, style: TextStyle(
          color: textColor,
        ),),
        callback: () {
          this.onPressed!();
        },
      ),
    );

    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(30),
    //   child: FlatButton(
    //
    //     onPressed: () {
    //       this.onPressed!();
    //     },
    //
    //     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    //     color: buttonColor,
    //     child: Text(
    //       buttonText!,
    //       style: TextStyle(color: textColor),
    //     )
    //   ),
    // );
  }
  
}