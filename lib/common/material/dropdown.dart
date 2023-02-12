import "package:flutter/material.dart";
import 'package:mobile_frontend/constraints.dart';


class Dropdown extends StatefulWidget {

  List? items = [];
  String pickedValue;
  Function(String) whenOnChange;

  Dropdown({Key? key, this.items, required this.pickedValue, required this.whenOnChange}) : super(key: key);

  @override
  _Dropdown createState() => _Dropdown(items, pickedValue, whenOnChange);
}

class _Dropdown extends State<Dropdown> {

  List? items = [];
  String pickedValue;
  Function(String) whenOnChange;

  _Dropdown(List? items, this.pickedValue, this.whenOnChange) {
    this.items = items;
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    
    return new Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      height: 50,
      decoration: BoxDecoration(
        color: yellowSemi, 
        borderRadius: BorderRadius.circular(30), 
      ), 

      /**
       * custom the text field
       */
      child: DropdownButton<String>(
        value: pickedValue,
        icon: const Icon(Icons.arrow_downward),
        iconSize: 20,
        elevation: 16,
        iconEnabledColor: yellowStrong,
        style: const TextStyle(color: Colors.black),
        onChanged: (String? newValue) {
          setState(() {
            pickedValue = newValue!;
          });
          whenOnChange(pickedValue);
        },
        
        items: this.items as List<DropdownMenuItem<String>>?,
      ),
    
    );
  }

}