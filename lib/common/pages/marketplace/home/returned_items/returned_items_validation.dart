import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/constraints.dart';

class ReturnedItemValidationModal extends StatelessWidget {

  final Function() confirmCallback;

  const ReturnedItemValidationModal({Key? key, required this.confirmCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("J'ai reçu l'article renvoyé par le client.", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),),

        SizedBox(height: sizedBoxHeight,),

        BigButton(
          icon: Icon(Icons.check),
          text: Text("J'ai reçu le retour."),
          background: lightGreen,
          callback: () {
            confirmCallback();
          },
        )

      ],

    );
  }

}