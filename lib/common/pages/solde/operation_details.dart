import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/classes/operation.dart';
import 'package:mobile_frontend/common/classes/ordered_item.dart';
import 'package:mobile_frontend/common/classes/string-cut.dart';
import 'package:mobile_frontend/constraints.dart';

class OperationDetails extends StatefulWidget {
  final Operation? operation;
  const OperationDetails({Key? key, this.operation}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OperationDetails();
}

class _OperationDetails extends State<OperationDetails> {

  bool showHistoric = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //paybackRequestDetailsBloc.findPaybackRequestDetails(widget.paymentRequestId!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 30,),

        // historic
        SizedBox(height: sizedBoxHeight,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Détail de l'opération", style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold,),),
          ],
        ),

        SizedBox(height: sizedBoxHeight,),
        Text(widget.operation!.description!, style: TextStyle(
            fontSize: 20),),

        SizedBox(height: sizedBoxHeight,),
        getHistoryList(widget.operation!)
      ],
    );
    /*
    return StreamBuilder<PaybackRequest?>(
      initialData: null,
      stream: paybackRequestDetailsBloc.stream,
      builder: (context, snapshot) {
        if(snapshot.data == null) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingIcon()
            ],
          );
        } else {
          if(snapshot.data!.currentStatus! == "REFUSED") {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 30,),

                // historic
                SizedBox(height: sizedBoxHeight,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Suivi de la demande", style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold,),),
                  ],
                ),

                SizedBox(height: sizedBoxHeight,),
                getHistoryList(snapshot.data!)
              ],
            );
          } else {
            return getPaybackContent(snapshot.data!);
          }
        }
      },
    );
     */
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

  getHistoryList(Operation op) {

    return Expanded(
      // height: paybackRequest.histories!.length * 50,
      child: ListView(
          scrollDirection: Axis.vertical,
          children: op.statusHistories!.map<Widget> ((StatusHistory statusHistory) {
            return Container(
              margin: EdgeInsets.only(bottom: 5),
              padding: EdgeInsets.only(bottom: 5),

              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.2, color: Colors.black),
                ),
              ),

              // child: Text("29/04/2020 à 15h46 : Paiement effectué sur Paydunya, reference XDZZDF", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
              child: Text("${StringWrapper.formatDate(statusHistory.statusDate!, true)}: ${statusHistory.description}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
            );
          }).toList()),
    );

    // StatusHistory statusHistory = paybackRequest.histories!.last;
    // return Text("${StringWrapper.formatDate(statusHistory.statusDate!, true)}: ${statusHistory.description}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300));
  }
/*
  getSalesList(PaybackRequest paybackRequest) {

    return Expanded(
        child: ListView(
            scrollDirection: Axis.vertical,
            children: paybackRequest.sales!.map<Widget> ((OrderedItem orderedItem) {
              return Container(
                margin: EdgeInsets.only(bottom: 5),
                padding: EdgeInsets.only(bottom: 5),

                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.2, color: Colors.black),
                  ),
                ),

                // child: Text("29/04/2020 à 15h46 : Paiement effectué sur Paydunya, reference XDZZDF", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
                child: getSaleDetails(orderedItem),
              );
            }).toList())
    );
  }

  getSaleDetails(OrderedItem sale) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Article: ${sale.itemName}"),
        Text("Acheteur: ${sale.username}"),
        Text("Acheté le: ${DateFormatter.formatDateTime(sale.creationDate.toString())}"),
        Text("Quantité : ${sale.quantity}"),
        Text("Prix unitaire : ${PriceFormat.formatePrice(sale.price!)}", style: TextStyle(fontWeight: FontWeight.bold),),
        Text("Total commande : ${PriceFormat.formatePrice(sale.price! * sale.quantity!)}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightGreen),),
      ],
    );
  }
*/
}