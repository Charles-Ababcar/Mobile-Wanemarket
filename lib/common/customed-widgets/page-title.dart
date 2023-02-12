import 'package:flutter/material.dart';

/**
 * Title of page
 */
class PageTitle extends StatelessWidget {

  late String title;

  PageTitle(String title) {
    this.title = title;
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: Text(this.title, style: TextStyle(fontWeight: FontWeight.bold,),),
      margin: const EdgeInsets.only(top: 10, bottom: 20),
    );

  }
  
}