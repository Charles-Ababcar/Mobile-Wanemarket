
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/material/round-button.dart';
import 'package:mobile_frontend/constraints.dart';

class WaneCounter extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => _WaneCounter();

}

class _WaneCounter extends State<WaneCounter> {

  int value = 1;

  @override
  Widget build(BuildContext context) {
    return Row(

      children: [

        RoundButton(
          buttonColor: grayLight,
          icon: Icon(Icons.remove, size: 20),
          height: 50,
          width: 50,
          callback: () {
            setState(() {
              value--;            
            });
          },
        ),

        Container(
          height: 50,
          width: 50,
          child: Center(
            child: Text("${value.toString()}", style: TextStyle(fontSize: 20),),
          ),

          decoration: new BoxDecoration(
            color: yellowSemi,
            borderRadius: new BorderRadius.all(const Radius.circular(40.0))
          )
          
        ),

        RoundButton(
          buttonColor: grayLight,
          icon: Icon(Icons.add, size: 20),
          height: 50,
          width: 50,
          callback: () {
            setState(() {
              value++;            
            });
          },
        )

      ]

    );
  }



  
}