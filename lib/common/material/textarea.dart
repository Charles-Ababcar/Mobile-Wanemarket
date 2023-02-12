import "package:flutter/material.dart";
import 'package:mobile_frontend/constraints.dart';


class TextAreaContainer extends StatelessWidget {

  final String textFieldHintText;


  final void Function(Object?)? onSave;
  final String Function(Object?)? onValidate;
  final String? initialValue;

  const TextAreaContainer({Key? key, required this.textFieldHintText, this.onSave, this.onValidate, this.initialValue }): super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    
    return new Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 150,
      width: size.width,
      decoration: BoxDecoration(
        color: yellowSemi, 
        borderRadius: BorderRadius.circular(30), 
      ), 

      /**
       * custom the text field
       */
      child: TextFormField(
        maxLines: null,
        initialValue: this.initialValue == null ? "": this.initialValue,
        keyboardType: TextInputType.multiline,
        
        decoration: new InputDecoration(

          hintText: textFieldHintText,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none

        ),        

        validator: (Object? value) {
          String errorMsg = onValidate!(value);
          return errorMsg == "" ? null: errorMsg;
        },
        
        onSaved: (Object? value) {
          onSave!(value);
        } ,

      )

    );
  }
}