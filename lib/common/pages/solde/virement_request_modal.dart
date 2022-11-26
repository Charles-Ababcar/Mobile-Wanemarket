import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/solde/solde_debit.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/material/texfield_digits.dart';
import 'package:mobile_frontend/common/material/textfield.dart';
import 'package:mobile_frontend/constraints.dart';

class VirementRequestModal extends StatefulWidget {
  final Function() afterRequest;
  const VirementRequestModal({Key? key, required this.afterRequest})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _VirementRequestModal();
}

class _VirementRequestModal extends State<VirementRequestModal> {
  double? amount;
  SoldeDebitBloc? soldeDebitBloc = new SoldeDebitBloc();
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // error container
        getErrorContainer(),

        SizedBox(
          height: 20,
        ),
        getInfoContainer(),

        // form
        getForm(),
      ],
    );
  }

  getForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          amountFormField(),
          SizedBox(
            height: 20,
          ),
          getSubmitButton(context),
        ],
      ),
    );
  }

  ///
  /// Phone form field
  ///
  Widget amountFormField() {
    return TextFieldDigitsContainer(
      textFieldHintText: "Montant demandé",
      customedIcon: Icon(Icons.attach_money, size: 20),
      onValidate: (Object? value) {
        if (value.toString().isEmpty) {
          return "Le montant est requis";
        }
        return "";
      },
      onSave: (Object? value) {
        amount = double.parse(value.toString());
      },
    );
  }

  getSubmitButton(context) {
    return BigButton(
      background: yellowSemi,
      text: Text(
        "Envoyer",
        style: TextStyle(color: Colors.black),
      ),
      icon: Icon(
        Icons.check,
        color: Colors.black,
      ),
      callback: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          bool isDebited = await soldeDebitBloc!.debitAmount(amount!);
          if (isDebited) {
            this.widget.afterRequest();
          }
        }
      },
    );
  }

  ///
  /// error container
  ///
  getInfoContainer() {
    return InfoContainer(
      height: 130,
      icon: Icon(
        Icons.info_rounded,
        size: 40,
        color: yellowStrong,
      ),
      contentColor: yellowSemi,
      borderColor: yellowSemi,
      text: Text(
          "Votre demande de virement sera traitée sous deux semaines par les administrateurs de Wanémarket",
          style: TextStyle(fontSize: 13)),
    );
  }

  ///
  /// error container
  ///
  getErrorContainer() {
    return StreamBuilder<String?>(
      initialData: null,
      stream: soldeDebitBloc!.errorDebitStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return InfoContainer(
            icon:
                Icon(Icons.warning_amber_rounded, size: 40, color: Colors.red),
            contentColor: lightRed,
            borderColor: lightRed,
            height: 120,
            text: Text("${snapshot.data}", style: TextStyle()),
          );
        } else {
          return SizedBox(
            height: 0,
          );
        }
      },
    );
  }
}
