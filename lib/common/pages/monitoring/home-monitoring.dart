import 'package:flutter/material.dart';
import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/pages/monitoring/items-monitoring.dart/items-monitoring.dart';
import 'package:mobile_frontend/common/pages/monitoring/roles-monitoring.dart/roles-monitoring.dart';
import 'package:mobile_frontend/constraints.dart';

import 'marketplaces-monitoring/owners-monitoring.dart';

/**
 * Page principale d'accès aux rôles
 */
class HomeMonitoringWidget extends StatelessWidget {

  // Gestion des rôles
  // Surveillances des annonces
  // Demande adhésion annonceur

  List<Widget> buttonRoles = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
      body: Container(
        padding: EdgeInsets.all(10),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // modérateur roles
            getAdminMonitorButton(context),
            SizedBox(height: 20),
  
            // modérateurs annonces
            getAnnonceMonitorButton(context),
            SizedBox(height: 20),
  
            // modérateurs annonces
            getMarketplaceMonitorButton(context)

          ]
        ),

      )
    );
  }

  getAdminMonitorButton(context) {
    if(applicationState.isAdminMonitor()) {
      return BigButton(text: Text("Gestion des rôles"), background: yellowSemi, icon: Icon(Icons.rule), callback: () => {
        Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) {
              return new RolesMonitoringWidget();
            }
        ))
      });
    } else {
      return Container();
    }
  }

  getMarketplaceMonitorButton(context) {
    if(applicationState.isMarketplaceMonitor() || applicationState.isAdminMonitor()) {
      return BigButton(text: Text("Gestion des annonceurs"), background: yellowSemi, icon: Icon(Icons.person_add_sharp), callback: () => {
        Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) {
              return new OwnerMonitoringWidget();
            }
        ))
      });
    } else {
      return Container();
    }
  }

  getAnnonceMonitorButton(context) {
    if(applicationState.isAnnonceMonitor() || applicationState.isAdminMonitor()) {
      return BigButton(text: Text("Gestion des annonces"), background: yellowSemi, icon: Icon(Icons.article), callback: () => {
        Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) {
              return new ItemsMonitoringWidget();
            }
        ))
      });
    } else {
      return Container();
    }
  }



  
}