import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:mobile_frontend/common/classes/string-cut.dart';
import 'package:mobile_frontend/constraints.dart';


class TextFieldContainer extends StatelessWidget {

  final String textFieldHintText;
  final bool isPassword;
  final Icon? customedIcon;
  final String? initialValue;
  final bool numbersOnly;
  final int? maxLength;


  final void Function(Object?)? onSave;
  final String Function(Object?)? onValidate;
  final void Function(String?)? onSubmit;

  const TextFieldContainer({Key? key,
      required this.textFieldHintText, 
      this.isPassword = false, 
      this.customedIcon = null, 
      this.onSave, 
      this.onSubmit, 
      this.onValidate, 
      this.initialValue, 
      this.numbersOnly = false, 
      this.maxLength = 15
   }): super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return new Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      height: 60,
      width: size.width,
      decoration: BoxDecoration(
        color: yellowSemi, 
        borderRadius: BorderRadius.circular(30), 
      ), 

      /**
       * custom the text field
       */
      child: Center(
        child: TextFormField(
          cursorColor: yellowStrong,
          obscureText: isPassword,
          initialValue: initialValue == null ? null: initialValue,

          inputFormatters: [
            LengthLimitingTextInputFormatter(maxLength),
          ],

          // maxLength: maxLength,
          //key: formKey,
          
          decoration: new InputDecoration(

            icon: customedIcon,
            hoverColor: yellowStrong,

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
        },

        onFieldSubmitted: (String value) {
          
          if(onSubmit != null) {
            onSubmit!(value);
          }
          
        },

      ),
      )

    );
  }
}