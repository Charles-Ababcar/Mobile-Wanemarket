import 'package:flutter/material.dart';

import '../../constraints.dart';

class CustomMaterial extends StatelessWidget {

  final Widget? child;

  const CustomMaterial({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return Material (
      color: yellowLight,
      child: Container(
        height: size.height,
        width: size.width* 0.9,
        padding: EdgeInsets.only(top: 50, right: 10, left: 10),
        child: child,
      )

    );
  }

  
}