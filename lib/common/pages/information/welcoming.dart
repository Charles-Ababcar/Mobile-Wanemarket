import 'package:flutter/material.dart';
import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-connected-scaffold.dart';
import 'package:mobile_frontend/common/material/main-button.dart';
import 'package:mobile_frontend/constraints.dart';

class SignupWelcom extends StatelessWidget {

  // User? user = applicationState.authUser;

  @override
  Widget build(BuildContext context) {

   Size size = MediaQuery.of(context).size;

   return Material(
      color: yellowLight,
      child: Container(
        height: size.height,
        width: size.width,
        color: yellowLight,
      )
   ); 
  }
  
}