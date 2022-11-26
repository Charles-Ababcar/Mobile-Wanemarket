import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {

  final void Function()? callback;
  final Color? buttonColor;
  final Icon? icon;
  final double? width;
  final double? height;

  const RoundButton({Key? key, this.callback, this.buttonColor, this.icon, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        callback!();
      },
      child: Container(
          height: height,
          width: width,
          child: icon,

          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(30),
          )
      ),
    );
    // return FlatButton(
    //   minWidth: height,
    //   height: width,
    //   color: buttonColor,
    //   child: icon!,
    //   shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
    //
    //   onPressed: () => {
    //     callback!()
    //   }
    // );
  }
  
}