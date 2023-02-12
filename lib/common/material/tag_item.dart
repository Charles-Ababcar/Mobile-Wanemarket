
import 'package:flutter/material.dart';
import 'package:mobile_frontend/constraints.dart';

class TagItem extends StatelessWidget {


  final String? text;
  final void Function (String)? onTap;
  final void Function (String)? onLongPress;
  final Color color;

  const TagItem({Key? key, this.text, this.onTap, this.onLongPress, required this.color}): super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return InkWell(

      child: Container(
        height: 40,
        width: size.width,
        color: this.color,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(this.text.toString()),
            Icon(Icons.remove)
          ],
        ),
      ),

      /**
       * handle on click
       */
      onTap: () {
        onTap!(this.text.toString());
      },

      onLongPress: () {
        onLongPress!(this.text.toString());
      },



    );

  }
  
}