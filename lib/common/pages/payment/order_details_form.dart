import 'package:flutter/material.dart';
import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/classes/order.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-scrollable.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/material/main-button.dart';
import 'package:mobile_frontend/common/material/textarea.dart';
import 'package:mobile_frontend/common/material/textfield.dart';
import 'package:mobile_frontend/constraints.dart';

class OrderDetailsForm extends StatefulWidget {

  // remplir le form et renvoyer les données
  final void Function(Order order) callback;

  const OrderDetailsForm({Key? key, required this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderDetailsForm();

}

class _OrderDetailsForm extends State<OrderDetailsForm> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Order finalOrder = new Order();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    return getForm(size);
  }

  getForm(Size size) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[

          /**
           * textfield
           */
          addLabel("N° de téléphone de paiement"),
          SizedBox(height: 10),
          phoneInput(),
          SizedBox(height: sizedBoxHeight),

          /**
           * TextField adresse
           */
          addLabel("Addresse de livraison"),
          SizedBox(height: 10),
          addressInput(),
          SizedBox(height: sizedBoxHeight),

          /**
           * description
           */
          addLabel("Instructions de livraison"),
          SizedBox(height: 10),
          descriptionInput(),
          SizedBox(height: sizedBoxHeight),
          /**
           * connection button
           */
          sendingButton(),

        ],
      ),
    );
  }

  addLabel(String label) {
    return Row(
      children: [
        SizedBox(width: 5,),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold),)
      ],
    );
  }

  ///
  /// get phone field
  ///
  Widget phoneInput() {
    return TextFieldContainer(
      textFieldHintText: "N°Téléphone de la société",
      customedIcon: Icon(Icons.phone, size: 20),
      initialValue: applicationState.authUser!.phone,
      maxLength: 15,

      onValidate: (Object? value) {
        if(value.toString().isEmpty) {
          return "Saisir un n° de téléphone";
        }
        return "";
      },

      onSave: (Object? value) {
        finalOrder.phone = value.toString();
      },

    );
  }

  ///
  /// get get address field
  ///
  Widget addressInput() {
    return TextFieldContainer(
        textFieldHintText: "Adresse",
        initialValue: applicationState.authUser!.address,
        customedIcon: Icon(
            Icons.wallet_membership, size: 20),
        maxLength: 50,
        //key: _formKey,
        onValidate: (Object? value) {
          if (value.toString().isEmpty) {
            return "Le champ adresse est requis";
          }
          return "";
        },
        onSave: (Object? value) {
          finalOrder.address = value.toString();
        }
    );
  }

  ///
  /// get description field
  ///
  Widget descriptionInput() {
    return TextAreaContainer(
      textFieldHintText: "Instruction de commande ou de livraison",

      onValidate: (Object? value) {
        if(!value.toString().isEmpty && value.toString().length > 200) {
          return "La description ne doit pas dépasser 200 lettres";
        }
        return "";
      },

      onSave: (Object? value) {
        finalOrder.instructions = value.toString();
      },
    );
  }

  Widget sendingButton() {
    return MainButton(
        buttonText: "Valider la commande",
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            widget.callback(finalOrder);
          }
        }
    );
  }

}