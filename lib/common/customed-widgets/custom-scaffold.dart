import 'package:flutter/material.dart';

// consts
import 'package:mobile_frontend/constraints.dart';

class ScaffoldCustom extends StatelessWidget {

  final Widget? body;

  ScaffoldCustom({this.body});

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: false,

      backgroundColor: yellowLight,
      body: Center(child:  body)
    );
  }

}