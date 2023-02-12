import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/material/textfield.dart';
import 'package:mobile_frontend/constraints.dart';

class AdminFormWidget extends StatefulWidget {

  final bool Function(int, bool, bool, bool) callback;

  const AdminFormWidget({Key? key, required this.callback}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _AdminFormWidget();

}

class _AdminFormWidget extends State<AdminFormWidget> {

  int? id;
  bool addAdminRole = false;
  bool addAnnonceRole = false;
  bool addAnnonceurRole = false;

  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return  Padding(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              ///
              /// getTitle
              ///
              getTitle(),
              SizedBox(height: sizedBoxHeight,),

              ///
              /// phone field
              ///
              getPhoneFormField(),
              SizedBox(height: sizedBoxHeight,),

              ///
              /// admin role checkbox
              ///
              getAdminRoleCheckBox(),
              SizedBox(height: sizedBoxHeight,),

              ///
              /// items role checkbox
              ///
              getAnnonceRoleCheckBox(),
              SizedBox(height: sizedBoxHeight,),

              ///
              /// markt role checkbox
              ///
              getAnnonceurRoleCheckBox(),
              SizedBox(height: sizedBoxHeight,),

              ///
              /// validiate button
              ///
              validateButton()

            ]
        ),
      )
    );

  }

  getTitle() {
    return Center(
      child: Text(
        "Ajouter une personne par son identifiant Wanémarket. Choisissez les rôles à attribuer",
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20
        ),
      ),
    );
  }

  getPhoneFormField() {
    return TextFieldContainer(
      textFieldHintText: "ID - Wanémarket",
      customedIcon: Icon(Icons.mail, size: 20),
      initialValue: "",
      maxLength: 15,

      onValidate: (Object? value) {
        if(value.toString().isEmpty) {
          return "Le N° de téléphone est requis";
        }
        return "";
      },

      onSave: (Object? value) {
        setState(() {
          id = int.parse(value.toString());
        });
      },

    );
  }

  getAdminRoleCheckBox() {
    return Row(
      children: [
        Checkbox(
            value: addAdminRole,
            activeColor: yellowStrong,
            onChanged: (bool? value) {
              setState(() {
                addAdminRole = value!;
              });
            }
        ),

        Text(
          "Gestion des rôles",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15
          ),
        )
      ],
    );
  }

  getAnnonceRoleCheckBox() {
    return Row(
      children: [
        Checkbox(
            value: addAnnonceRole,
            activeColor: yellowStrong,
            onChanged: (bool? value) {
              setState(() {
                addAnnonceRole = value!;
              });
            }
        ),

        Text(
          "Validation des annonces",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15
          ),
        )
      ],
    );
  }

  getAnnonceurRoleCheckBox() {
    return Row(
      children: [
        Checkbox(
            value: addAnnonceurRole,
            activeColor: yellowStrong,
            onChanged: (bool? value) {
              setState(() {
                addAnnonceurRole = value!;
              });
            }
        ),

        Text(
          "Validation des annonceurs",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15
          ),
        )
      ],
    );
  }

  validateButton() {
    return BigButton(
      background: yellowSemi,
      text: Text("Ajouter les rôles"),
      icon: Icon(Icons.add),

      callback: () {

        if(_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          bool isDone = widget.callback(id!, addAdminRole, addAnnonceRole, addAnnonceurRole);

          if(isDone) {
            Navigator.pop(context);
          }

        }

      },

    );
  }

}