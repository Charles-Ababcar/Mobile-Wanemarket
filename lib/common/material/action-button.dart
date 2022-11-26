import 'package:flutter/material.dart';
import 'package:mobile_frontend/constraints.dart';

class ActionButton extends StatelessWidget {
  final Icon? icon;
  final Text? text;
  final Color? mainColor;
  final Color? borderColor;
  final Color? iconBackgroundColor;
  final void Function()? callback;
  final double? width;
  final double? height;

  const ActionButton({
    Key? key,
    this.icon,
    this.text,
    this.mainColor,
    this.borderColor,
    this.iconBackgroundColor,
    this.callback,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double? buttonHeight = height == null ? 50 : height;
    double? buttonWidth = width == null ? size.width : width;

    return GestureDetector(
        onTap: () => {callback!()},
        child: Container(
          height: buttonHeight,
          width: buttonWidth,
          margin: EdgeInsets.all(5),
          child: Row(
            children: [
              Container(
                height: buttonHeight,
                width: buttonHeight,
                child: icon,
                decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(15)),
              ),
              SizedBox(width: 5),
              Expanded(
                  child: Container(
                child: text,
              ))
            ],
          ),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(15),
            border: Border(
              top: BorderSide(width: 3.0, color: borderColor!),
              left: BorderSide(width: 3.0, color: borderColor!),
              right: BorderSide(width: 3.0, color: borderColor!),
              bottom: BorderSide(width: 3.0, color: borderColor!),
            ),
          ),
        ));
  }
}
