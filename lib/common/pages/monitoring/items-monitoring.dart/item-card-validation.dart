import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/admin/annonces/annonce-list-bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/material/item-card/label-item.dart';
import 'package:mobile_frontend/common/material/round-button.dart';
import 'package:mobile_frontend/common/pages/item/items-description.dart';
import 'package:mobile_frontend/constraints.dart';

class ItemCardValidation extends StatefulWidget {

  final Item item;

  const ItemCardValidation({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemCardValidation();
}

class _ItemCardValidation extends State<ItemCardValidation> {

  bool? isValidated;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    // TODO: implement build
    return GestureDetector(

      child: Container(
          height: 130,
          width: size.width,
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
          padding: EdgeInsets.all(5),

          decoration: BoxDecoration(
              color: getColor(),
              borderRadius: new BorderRadius.all( const Radius.circular(15.0))
            //border: Border(bottom: BorderSide(width: 2,color: yellowSemi))
          ),

          child: content(context, size)

      ),

      onTap: () {
        // showRequestDetails(context);
        if(showButtons()) {
          Popup.modal(context, ItemDescription(itemId: widget.item.id!, isAdmin: true));
        }
      },

    );
  }

  Widget content(context, size) {
    return Column(
      children: [
        Text("${widget.item.title}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),

        SizedBox(height: 5),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            showButtons() ? Text("Cliquez pour voir le détail de l'annonce"): Container(),
            // LabelItem(icon: Icon(Icons.person, size: 15), text: "$Cliq"),
          ],
        ),

        actionButtons(context),

        SizedBox(height: 5),
      ],
    );
  }

  Widget actionButtons(context) {
    return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // modifier
            showButtons() ? RoundButton(
                height: 50,
                width: 50,
                icon: Icon(Icons.done),
                buttonColor: lightGreen,
                callback: () {
                  // shiwRequestAcceptSheet(context)
                  acceptAnnonce();
                }
            ): Container(),

            // supprimer
            showButtons() ? RoundButton(
              height: 50,
              width: 50,
              icon: Icon(Icons.delete, size: 20),
              buttonColor: lightRed,
              callback: () {
                // shiwRequestDeclineSheet(context)
                refuseAnnonce();
              }
            ): Container(),

          ],
        )
    );
  }

  acceptAnnonce() {
    showDialog(context: context, builder: (context) => Popup.confirmAnnonceDecision(context, true, () {
      AnnonceListBloc.annonceDecision(widget.item.id!, true);
      setState(() {
        isValidated = true;
      });
    }));
  }

  refuseAnnonce() {
    showDialog(context: context, builder: (context) => Popup.confirmAnnonceDecision(context, false, () {
      AnnonceListBloc.annonceDecision(widget.item.id!, false);
      setState(() {
        isValidated = false;
      });
    }));
  }

  getColor() {
    if(isValidated == null) return yellowSemi;
    if(isValidated!) return lightGreen;
    if(!isValidated!) return lightRed;
  }

  showButtons() {
    return isValidated == null;
  }

  //
  //
  // showStatus(Size size) {
  //   if(purchaseOrder!.status == "ACCEPTED") {
  //
  //     var text = "Veuillez rendre votre produit disponible";
  //     return statusLabel(size, text, lightGreen);
  //
  //   } else {
  //     inspect(purchaseOrder);
  //     var text = DeclinReason.getReasonById(purchaseOrder!.status!);
  //     return statusLabel(size, text, lightRed);
  //   }
  //
  // }
  //
  // statusLabel(Size size, String text, Color color) {
  //   return Padding(
  //     padding: EdgeInsets.all(10),
  //     child: Container(
  //
  //       height: 40,
  //       width: size.width * 0.75,
  //       color: color,
  //
  //       child: Center(
  //         child: Text(text),
  //       ),
  //
  //     ),
  //
  //   );
  // }
  //
  // showRequestDetails(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       enableDrag: true,
  //       isScrollControlled: true,
  //       elevation: 80.0,
  //
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.vertical(
  //               top: Radius.circular(10)
  //           )
  //       ),
  //
  //       builder: (context) => PurchaseOrderDetails(this.purchaseOrder!)
  //   );
  // }
  //
  // shiwRequestAcceptSheet(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       enableDrag: true,
  //       isScrollControlled: true,
  //       elevation: 80.0,
  //
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.vertical(
  //               top: Radius.circular(10)
  //           )
  //       ),
  //
  //       builder: (context) => PurchaseOrderAcceptWidget(this.purchaseOrder!)
  //   );
  // }
  //
  // shiwRequestDeclineSheet(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       enableDrag: true,
  //       isScrollControlled: true,
  //       elevation: 80.0,
  //
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.vertical(
  //               top: Radius.circular(10)
  //           )
  //       ),
  //
  //       builder: (context) => PurchaseOrderDeclineWidget(this.purchaseOrder!)
  //   );
  // }

}