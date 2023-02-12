import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/admin/annonces/annonce-list-bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-material.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/pages/monitoring/items-monitoring.dart/item-card-validation.dart';
import 'package:mobile_frontend/constraints.dart';

class ItemsMonitoringWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ItemsMonitoringWidget();

}

class _ItemsMonitoringWidget extends State<ItemsMonitoringWidget>  {

  AnnonceListBloc annonceListBloc = new AnnonceListBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    annonceListBloc.loadAnnonceList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    annonceListBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: yellowStrong,),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(children: [
          SizedBox(height: 20,),
          InfoContainer(
            contentColor: yellowSemi,
            borderColor: yellowLight,
            icon: Icon(Icons.info_rounded, size: 40, color: yellowStrong,),
            text: Text("Veuillez vérifier puis autoriser ou refuser la publication d'annonces.")
          ),

        
          StreamBuilder<List<Item>?>(
            stream: annonceListBloc.itemListStream,
            builder: (context, snaphost) {
              if(snaphost.hasData) {
                return Expanded(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: snaphost.data!.map<Widget> ((Item item) {
                      return ItemCardValidation(item: item);
                  }).toList(),
                ));
              } else {
                return LoadingIcon();
              }
            },
          ),

        BigButton(
          background: yellowSemi,
          text: Text("Recharger"),
          icon: Icon(Icons.sync),
          callback: () {
            annonceListBloc.loadAnnonceList();
          },
        )

      ])
    );
  }

}