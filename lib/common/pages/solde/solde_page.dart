import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/solde/solde_bloc.dart';
import 'package:mobile_frontend/common/classes/operation.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/classes/price-format.dart';
import 'package:mobile_frontend/common/classes/solde.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/pages/solde/operation_details.dart';
import 'package:mobile_frontend/common/pages/solde/virement_request_modal.dart';
import 'package:mobile_frontend/constraints.dart';

class SoldePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SoldePage();

}

class _SoldePage extends State<SoldePage> {

  SoldeBloc soldeBloc = new SoldeBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Solde? solde;
    soldeBloc.loadUserSolde();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Material(
      child: Stack(
        children: [

          SizedBox(height: 50,),

          StreamBuilder<Solde?>(
            stream: soldeBloc.soldeStream,
            initialData: null,
            builder: (context, snapshot) {
              if(snapshot.data == null) {
                return LoadingIcon();
              } else {
                return getContainer(snapshot.data!, size);
              }
            },
          )

        ],
      ),
    );
  }

  getInformationContainer() {
    return InfoContainer(
      height: 180,
      icon: Icon(
        Icons.info_rounded,
        size: 40,
        color: yellowStrong,
      ),
      contentColor: yellowSemi,
      borderColor: yellowSemi,
      text: Text(
          "Voici votre solde. Vous pouvez tout vos bénéfices.\nVeuillez cliquer sur le bouton tout en bas, Wanémarket ne tardera pas à vous répondre.",
          style: TextStyle(fontSize: 13)
      ),
    );
  }

  getContainer(Solde solde, Size size) {
    return Column(
      children: [

        // solde
        SizedBox(height: 50,),
        Center(child: getInformationContainer(),),
        SizedBox(height: 30,),
        Center(child: getCurrentSolde(solde.currentAmount!)),

        getHistoryList(solde.operations),

        Container(
          width: size.width * 0.9,
          child: getOrderButton(context),
        )

      ],
    );
  }

  getCurrentSolde(double amount) {
    return Text("${PriceFormat.formatePrice(amount)}", style: TextStyle(
      color: Colors.lightGreen,
      fontSize: 30,
      fontWeight: FontWeight.bold
    ),);
  }

  Expanded getHistoryList(List<Operation>? operations) {
    return Expanded(
        child: ListView(
            scrollDirection: Axis.vertical,
            children: operations!.map<Widget>((Operation op) {
              return Padding(padding: EdgeInsets.only(left: 10, right: 10), child: getOperationCard(op),);
            }).toList()));
  }

  getOperationCard(Operation op) {
    return GestureDetector(

      onTap: () {
        Popup.modal(context, new OperationDetails(operation: op,));
      },

      child: Container(
        height: 60,
        width: 100,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.only(left: 20, right: 20),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getIconAccordingToStatus(op.status!),

            SizedBox(width: 10,),
            op.type == "CREDIT" ? Icon(Icons.add, color: Colors.green,): Icon(Icons.remove, color: Colors.red,),
            op.type == "CREDIT" ? Text("${PriceFormat.formatePrice(op.amount!)}", style: TextStyle(fontSize: 18, color: Colors.green),): SizedBox(width: 0,),
            op.type == "DEBIT" ?  Text("${PriceFormat.formatePrice(op.amount!)}", style: TextStyle(fontSize: 18, color: Colors.red),): SizedBox(width: 0,),
          ],
        ),

        decoration: BoxDecoration(
            color: yellowSemi,
            // color: yellowSemi,
            borderRadius : new BorderRadius.all(const Radius.circular(30.0))
        ),
      ),
    );
  }

  Icon getIconAccordingToStatus(String status) {
    if(status == "WAITING") {
      return Icon(Icons.access_time_filled , color: lightGrey, size: 30,);
    } else if(status == "VALIDATED") {
      return Icon(Icons.check, color: Colors.lightGreen, size: 30);
    } else if(status == "TREATED") {
      return Icon(Icons.lock, color: Colors.black, size: 30);
    } else {
      return Icon(Icons.highlight_remove, color: lightRed, size: 30);
    }
  }

  String getStatusString(String status) {
    if(status == "WAITING") {
      return "En attente";
    } else if(status == "ACCEPTED") {
      return "Acceptée";
    } else if(status == "TREATED") {
      return "Traitée";
    } else {
      return "Refusée";
    }
  }

  getOrderButton(context) {
    return BigButton(
      background: yellowSemi,
      text: Text("Demander un virement"
        , style: TextStyle(color: Colors.black),),
      icon: Icon(Icons.add, color: Colors.black,),
      callback: () {
        Popup.modal(context, VirementRequestModal(
          afterRequest: () {
            soldeBloc.loadUserSolde();
            Navigator.of(context).pop();
          },
        ));
      },
    );
  }

}