import 'package:flutter/material.dart';
import 'package:mobile_frontend/constraints.dart';


class EmptyWave extends StatelessWidget {

  final String? text;
  final IconData? icon;

  const EmptyWave({Key? key, this.text, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color backgroundColor = yellowSemi;

    return Center(
      child:  Container(

          height: 150,
          width: 220,

          decoration: new BoxDecoration(
            color: backgroundColor,
            borderRadius: new BorderRadius.circular(50)
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: yellowStrong),
              SizedBox(height: 30),
              Text("${text}", style: TextStyle(fontSize: 12, color: yellowStrong))
            ]
        ),

      ),
        
    );
  }
  
}