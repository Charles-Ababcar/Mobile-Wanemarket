import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InfoContainer extends StatelessWidget {

  final Color? borderColor;
  final Color? contentColor;
  final Icon? icon;
  final Text? text;

  final double? height;
  final double? width;
  final SpinKitCircle? spinKitCircle;

  const InfoContainer({Key? key, this.borderColor, this.contentColor, this.icon, this.text, this.height, this.width, this.spinKitCircle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // TODO: implement build
    return Container(
      height: height == null ? 150: height,
      width:  width == null ? size.width * 0.90: width ,
      padding: EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: contentColor,
        borderRadius: BorderRadius.circular(15),
        border: Border(
          top:    BorderSide(width: 3.0, color: borderColor!),
          left:   BorderSide(width: 3.0, color: borderColor!),
          right:  BorderSide(width: 3.0, color: borderColor!),
          bottom: BorderSide(width: 3.0, color: borderColor!),
        ),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 5),
            child: icon == null ? spinKitCircle : icon//Icon(Icons.info_rounded, size: 40, color: yellowStrong,),
          ),
          text!
          /*Text("Wanémarket vous offre la possibilité "
              + "de créer votre espace annonceur pour vendre "
              + "vos articles. Veuillez remplir ce "
              + "formulaire, les administrateurs étudierons votre demande.",style: TextStyle())*/
        ]
      ),
    );
  }
  
}