import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/classes/price-format.dart';
import 'package:mobile_frontend/constraints.dart';

  /**
   * Graphic content with wane signature which
   * show the price of elem, resizable
   */
class ItemPrice extends StatelessWidget {

  final EdgeInsets? margin;
  final double height;
  final double width;
  final double price;
  final double? fontSize;

  const ItemPrice({Key? key, required this.margin, required this.height, required this.width, required this.price, this.fontSize}): super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container (
      margin: margin,
      height: this.height,
      width: this.width,
      child: Center(
        child: Text(
            PriceFormat.formatePrice(this.price),
            style: TextStyle(color: Colors.white, fontSize: getFontSize()))
      ),

      decoration: BoxDecoration(
          color: yellowStrong,
          borderRadius: new BorderRadius.all(const Radius.circular(8.0))
      ),

    );

  }

  double getFontSize() {
    if(fontSize == null)
      return 14;
    else return fontSize!;
  }

}