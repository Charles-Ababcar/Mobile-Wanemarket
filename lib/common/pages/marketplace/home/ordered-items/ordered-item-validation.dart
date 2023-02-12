import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/constraints.dart';


class OrderedItemValidationModal extends StatelessWidget {

  final Function() actionCallback;

  const OrderedItemValidationModal({Key? key, required this.actionCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Le coli est prêt, cliquez sur le bouton pour prévenir Wanémarket. Un livreur viendra le récupérer. \nPassé cela, vous ne pouvez plus annuler.", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),),

        SizedBox(height: sizedBoxHeight,),

        BigButton(
          icon: Icon(Icons.check),
          text: Text("Le coli est prêt."),
          background: lightGreen,
          callback: () {
            this.actionCallback();
          },
        )
      ],
    );

  }

}