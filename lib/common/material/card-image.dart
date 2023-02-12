import 'package:flutter/cupertino.dart';
import 'package:mobile_frontend/common/classes/article.dart';

import '../../constraints.dart';

class CardImage extends StatelessWidget {

  Item? item;

  final double? height;
  final double? width;

  CardImage({this.item, this.height, this.width});

  @override
  Widget build(BuildContext context) {

    return Container(
        height: this.height,
        width: this.width,
        child: ClipRRect(
          borderRadius:  new BorderRadius.all(const Radius.circular(15.0)),
          child: this.injectImage(),
        )
    );

  }

  injectImage() {
    if (item!.photos  != null && item!.photos.length > 0)
      return Image.network(item!.photos[0].url!, fit: BoxFit.contain,);
    else
      return Image.asset(WANE_LOGO, fit: BoxFit.contain,);
  }



}