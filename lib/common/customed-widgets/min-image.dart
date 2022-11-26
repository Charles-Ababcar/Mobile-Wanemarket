import 'package:flutter/cupertino.dart';
import 'package:mobile_frontend/constraints.dart';

class MinImage extends StatelessWidget {

  final String? imageUrl;

  const MinImage({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,

      child: ClipRRect(
        borderRadius:  new BorderRadius.all(const Radius.circular(15.0)),
        child: Center(
          child: Image.asset(WANE_LOGO, fit: BoxFit.cover,),
        ),
      ),

      decoration: BoxDecoration(
        color: yellowSemi,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }


}