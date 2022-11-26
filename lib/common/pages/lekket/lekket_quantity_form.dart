import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/article/article_description_bloc.dart';
import 'package:mobile_frontend/common/bloc/article/article_lekket_action.dart';
import 'package:mobile_frontend/common/bloc/article/article_lekket_edit.dart';
import 'package:mobile_frontend/common/bloc/article/purchase_list_bloc.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/classes/purchase_order.dart';
import 'package:mobile_frontend/common/material/dropdown.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/material/round-button.dart';
import 'package:mobile_frontend/constraints.dart';

class LekketQuantityForm extends StatefulWidget {
  const LekketQuantityForm({Key? key, required this.itemLekket}) : super(key: key);


  @override
  State<LekketQuantityForm> createState() => _LekketQuantityForm();
  
  final ItemLekket itemLekket;


}

class _LekketQuantityForm extends State<LekketQuantityForm>  {

  /**
   * 
   */
  ItemLekketEditBloc itemEditBloc = new ItemLekketEditBloc();
  ItemLekketActionBloc lekketActionBloc = new ItemLekketActionBloc();

  int? finalQuantityPicked;

  @override
  void dispose() {
    super.dispose();
    itemEditBloc.dispose();
    lekketActionBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(

        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          widget.itemLekket.instructions != null ? Container() : Text("Vous n'avez ajouté aucune indication pour cet article", style: TextStyle(
            fontWeight: FontWeight.bold,
          ),),



          widget.itemLekket.instructions == null ? Container() : Text("Indications supplémentaires pour l'article:", style: TextStyle(
            fontWeight: FontWeight.bold,
          ),),


          widget.itemLekket.instructions == null ? Container() : Text("${widget.itemLekket.instructions}", style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 25
          ),),

        ]

      );
  }

}