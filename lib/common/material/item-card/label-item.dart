import 'package:flutter/material.dart';


class LabelItem extends StatelessWidget {

  final String? text;
  final Icon? icon;
  final double? fontSize;

  const LabelItem({Key? key, this.text, this.icon, this.fontSize}): super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
        children: [
        icon!,
        SizedBox(width: 5),
        Text(this.text!, style: TextStyle(fontSize: fontSize == null ? 11: fontSize, fontWeight: FontWeight.w300),)
      ]);
  }
  
}