import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/admin/roles/admin_list_bloc.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-material.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/material/textfield.dart';
import 'package:mobile_frontend/common/pages/monitoring/roles-monitoring.dart/user-roles-card.dart';
import 'package:mobile_frontend/constraints.dart';

import 'admin-form.dart';

/**
 * Page de gestion de tout les rôles
 */
class RolesMonitoringWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RolesMonitoringWidget();

}

class _RolesMonitoringWidget extends State<RolesMonitoringWidget> {

  AdminListBloc adminListBloc = AdminListBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminListBloc.loadAdminList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    adminListBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {


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
      body: Column(
        children: [

          SizedBox(height: 20,),
          ///
          /// Error stream
          ///
          getErrorStream(),

          /**
           * Liste des admins avec leur roles
           */
          // getTextField(),
          // SizedBox(height: 10),

          // get infos about rôles
          Row (
            children: [
              Icon(Icons.rule, size: 20, color: Colors.black,),
              SizedBox(width: 5),
              Text("Gestion des rôles")
            ],
          ),

          Row (
            children: [
              Icon(Icons.article, size: 20, color: Colors.black,),
              SizedBox(width: 5),
              Text("Gestion des annonces")
            ],
          ),

          Row (
            children: [
              Icon(Icons.person_add_sharp, size: 20, color: Colors.black,),
              SizedBox(width: 5),
              Text("Gestion des annonceurs")
            ],
          ),
          
          SizedBox(height: 10),

          ///
          /// admin list
          ///
          getAdminList(),

          ///
          /// add new admin button
          ///
          getAddAdminButton()

        ],
      ),

    );

  }

  getAddAdminButton() {
    return BigButton(
      callback: () {
        Popup.modal(context, AdminFormWidget(
          callback: (userId, admiNRole, annonceRole, annonceurRole) {
            adminListBloc.addRoleToUser(userId, admiNRole, annonceRole, annonceurRole);
            return true;
          }
        )
        );
      },
      background: yellowSemi,
      icon: Icon(Icons.add),
      text: Text("Ajouter un nouvel admin"),
    );
  }

  getTextField() {
    return TextFieldContainer(
        textFieldHintText: "Recherche rapide",
        customedIcon: Icon(Icons.person, size: 20)
    );
  }

  getErrorStream() {
    return StreamBuilder<String?> (
      stream: adminListBloc.errorStream,
      initialData: null,
      builder: (context, snapshot) {

        // si rien, affiche rien
        if(snapshot.data == null) {
          return Container();
        } else if(snapshot.hasData) {
          return Column (
            children: [

              InfoContainer(
                icon: Icon(Icons.warning_amber_rounded, size: 40, color: Colors.red),
                contentColor: lightRed,
                borderColor: lightRed,
                height: 100,
                text: Text(snapshot.data.toString().toLowerCase(), style: TextStyle()),
              ),

              SizedBox(height: sizedBoxHeight),
            ],
          );
        } else {
          return new Container();
        }
      }
    );
  }

  getAdminList() {
    return StreamBuilder< List<User>? >(
      stream: adminListBloc.adminListStream,
      initialData: null,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          List<User>? adminList = snapshot.data;
          return Expanded(
            child: ListView(
                scrollDirection: Axis.vertical,
                children: adminList!.map<Widget> ((user) {
                  return UserMonitoringCard(userId: user.id!);
                }).toList()
            ));
        } else {
          return LoadingIcon();
        }
      },
    );
  }

}
