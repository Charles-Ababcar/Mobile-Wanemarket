import 'package:flutter/material.dart';

class CustomScrollable extends StatelessWidget {

  final Widget? child;

  CustomScrollable({this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(          
      reverse: false,
      child: Padding(
        padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom),
        child: child
      )
    );
  }

}