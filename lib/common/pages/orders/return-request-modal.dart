import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/return_request_bloc.dart';
import 'package:mobile_frontend/common/classes/return_request.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/material/dropdown.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/material/texfield_digits.dart';
import 'package:mobile_frontend/common/material/textarea.dart';
import 'package:mobile_frontend/common/material/textfield.dart';
import 'package:mobile_frontend/constraints.dart';


class ReturnRequestModal extends StatefulWidget {

  final int orderedItemId;

  const ReturnRequestModal({Key? key, required this.orderedItemId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReturnRequestModal();

}

class _ReturnRequestModal extends State<ReturnRequestModal> {

  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  ReturnRequestBloc requestBloc = new ReturnRequestBloc();

  List<String> motifs = [
    "L'article est défectueux ou ne fonctionne pas",
    "L'article reçu n'est pas le bon",
    "Produit endommagé",
    "Article incompatible",
    "Description erronée sur le site",
    "Pièces ou accessoires manquants",
    "Arrivé en plus de ce qui a été commandé",
    "Autre … (à préciser -sur champs-)"
  ];

  String? currentMotif;
  ReturnRequest returnRequest = new ReturnRequest();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentMotif = motifs[0];
    returnRequest.reason = currentMotif;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    requestBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool?>(
      initialData: null,
      stream: requestBloc.stream,
      builder: (context, snapshot) {
        if(snapshot.data == null) {
          return Form(
            key: _formKey,
            child: getColumn(),
          );
        } else {
          if(snapshot.data == true) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getInfoContainer(true)
              ],);
          } else {
            // loading
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingIcon(),
              ],);
          }
        }
      },
    );
  }

  getColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // information
        getInfoContainer(false),
        SizedBox(height: sizedBoxHeight,),
        getErrorContainer(),

        SizedBox(height: sizedBoxHeight,),
        Row (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Text("Motif:", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),),
            Center(child: getReason()),
          ],
        ),

        SizedBox(height: sizedBoxHeight,),
        getDescription(),

        SizedBox(height: sizedBoxHeight * 0.8),
        getSubmitButton(),

      ],

    );
  }

  getErrorContainer() {
    return StreamBuilder<String?>(
      initialData: null,
      stream: requestBloc.streamError,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          print("error is not null");
          return InfoContainer(
            icon: Icon(Icons.warning_amber_rounded, size: 40, color: Colors.red),
            contentColor: lightRed,
            borderColor: lightRed,
            height: 100,
            text: Text("${snapshot.data}", style: TextStyle()),
          );
        } else {
          print("error is null");
          return SizedBox(height: 0,);
        }
      },
    );
  }

  getInfoContainer(bool check) {
    return InfoContainer(
        height: 150,
        contentColor: yellowSemi,
        borderColor: yellowStrong,
        icon: check ? Icon(Icons.check, size: 40, color: yellowStrong,): Icon(Icons.info_rounded, size: 40, color: yellowStrong,),
        text: Text("Les administrateurs vérifieront votre demande, une fois acceptée. Le coli sera récupéré par un livreur. \n Une fois receptionnée par l'annonceur, nous vous rembourserons.")
    );
  }

  Widget getReason() {
    return Dropdown(
        pickedValue: currentMotif.toString(),

        whenOnChange: (String newValue) {
          setState(() {
            currentMotif = newValue;
            this.returnRequest.reason = currentMotif;

          });
        },

        items: motifs.map<DropdownMenuItem<String>>((String motif) {
          return DropdownMenuItem<String>(
            value: motif,
            child: Text(motif),
            // child: Text("ok!"),
          );
        }).toList()
    );
  }

  Widget getDescription() {
    return TextAreaContainer(
      textFieldHintText: "Veuillez expliquer votre demande",
      initialValue:  "",

      onValidate: (Object? value) {
        if(!value.toString().isEmpty && value.toString().length > 200) {
          return "La description ne doit pas dépasser 200 lettres";
        }
        return "";
      },

      onSave: (Object? value) {
        this.returnRequest.description = value.toString();
      },
    );
  }

  getSubmitButton() {
    return BigButton(
      background: yellowSemi,
      text: Text("Soumettre la demande"
        , style: TextStyle(color: Colors.black),),
      icon: Icon(Icons.check, color: Colors.black,),

      callback: () {

        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          returnRequest.orderedItemId = widget.orderedItemId;
          requestBloc.createReturnRequest(returnRequest);
        }

      });
  }

}
