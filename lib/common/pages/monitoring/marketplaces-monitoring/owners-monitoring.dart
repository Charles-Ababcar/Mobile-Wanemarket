import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/admin/marketplaces/marketplace-list-bloc.dart';
import 'package:mobile_frontend/common/classes/marketplace.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-material.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/constraints.dart';

import 'marketplace-card.dart';

class OwnerMonitoringWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OwnerMonitoringWidget();
}

class _OwnerMonitoringWidget extends State<OwnerMonitoringWidget>  {

  MarketplaceListBloc marketplaceListBloc = new MarketplaceListBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    marketplaceListBloc.loadMarketplaceList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    marketplaceListBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;

    return CustomMaterial(
      child: Column(children: [
        InfoContainer(
          contentColor: yellowSemi,
          borderColor: yellowLight,
          icon: Icon(Icons.info_rounded, size: 40, color: yellowStrong,),
          text: Text("Plusieurs personnes veulent publier des annonces."
                    + "Vous devez vérifier leurs société, prendre contact avec eux."
                    + "Ainsi, vous pourrez valider ou refuser la demande d'adhésion.")
        ),

        StreamBuilder<List<Marketplace>?>(
          stream: marketplaceListBloc.marketplaceListStream,
          initialData: null,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: snapshot.data!.map<Widget> ((Marketplace place) {
                    return MarketplaceCard (
                      marketplace: place,
                    );
                }).toList(),
              ));
            } else {
              return LoadingIcon();
            }
          }
        ),

        BigButton(
          background: yellowSemi,
          text: Text("Recharger"),
          icon: Icon(Icons.sync),
          callback: () {
            marketplaceListBloc.loadMarketplaceList();
          },
        )

      ])
    );
  }

}
