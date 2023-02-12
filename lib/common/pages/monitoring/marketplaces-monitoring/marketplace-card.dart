import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/admin/marketplaces/marketplace-list-bloc.dart';
import 'package:mobile_frontend/common/classes/marketplace.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/material/round-button.dart';
import 'package:mobile_frontend/constraints.dart';

class MarketplaceCard extends StatefulWidget {
  final Marketplace marketplace;
  const MarketplaceCard({Key? key, required this.marketplace}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MarketplaceCard();

}

class _MarketplaceCard extends State<MarketplaceCard> {

  bool? isValidated;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    // TODO: implement build
    return GestureDetector(
      onTap: () => Popup.modal(context, MarketplaceDetails(marketplace: widget.marketplace)),
      child: getContent(size),
    );

  }

  getContent(size) {
    return Container(
      child: Container(
        height: 120,
        width: size.width,
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        padding: EdgeInsets.all(5),

        decoration: BoxDecoration(
            color: getColor(),
            borderRadius: new BorderRadius.all( const Radius.circular(15.0))
          //border: Border(bottom: BorderSide(width: 2,color: yellowSemi))
        ),

        child: Column(
          children: [
            SizedBox(height: 10),
            Text("${widget.marketplace.name}", style: TextStyle(fontWeight: FontWeight.bold)),

            Expanded(child: Row(
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
                      acceptMarketplace();
                    }
                ): Container(),

                // supprimer
                showButtons() ? RoundButton(
                    height: 50,
                    width: 50,
                    icon: Icon(Icons.delete, size: 20),
                    buttonColor: lightRed,
                    callback: () {
                      refuseMarketplace();
                    }
                ): Container(),

              ],
            ),)
          ],
        ),

      ));
  }

  acceptMarketplace() {

    showDialog(context: context, builder: (context) => Popup.confirmMarketplaceDecision(context, true, () {

      MarketplaceListBloc.marketplaceDecision(widget.marketplace.id!, true);
      setState(() {
        isValidated = true;
      });

    }));


  }

  refuseMarketplace() {

    showDialog(context: context, builder: (context) => Popup.confirmMarketplaceDecision(context, false, () {

      MarketplaceListBloc.marketplaceDecision(widget.marketplace.id!, false);
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
  
}


class MarketplaceDetails extends StatelessWidget {

  final Marketplace marketplace;

  const MarketplaceDetails({Key? key, required this.marketplace}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;


    return Padding(
        padding: EdgeInsets.all(20),

        child: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            // item
            infoItem(size, "Nom","${marketplace.name}"),
            SizedBox(height: sizedBoxHeight),

            // item
            infoItem(size, "Ville","${marketplace.location!.title}"),
            SizedBox(height: sizedBoxHeight),

            // item
            infoItem(size, "Adresse","${marketplace.address}"),
            SizedBox(height: sizedBoxHeight),

            // item
            infoItem(size, "Téléphone","${marketplace.phone}"),
            SizedBox(height: sizedBoxHeight),
            SizedBox(height: sizedBoxHeight),

            Text(
              "${marketplace.description}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            )

          ],

        )
    );
  }

  Widget infoItem(Size size, String title, String text) {
    // information container
    return Container(
        width: size.width,
        height: 50,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: yellowSemi,
          boxShadow: [
            BoxShadow(color: yellowStrong, spreadRadius: 3),
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20),

            Text("${title} :", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
            )),

            SizedBox(width: 5),

            Text("${text}", style: TextStyle(
                fontSize: 18
            )),

          ],
        )

    );

  }

}