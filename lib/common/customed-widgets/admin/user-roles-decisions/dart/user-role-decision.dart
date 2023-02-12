import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/admin/roles/user_role_bloc.dart';
import 'package:mobile_frontend/common/classes/AdminChecker.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/constraints.dart';

class UserRoleDecision extends StatefulWidget {

  final int userId;

  const UserRoleDecision({Key? key, required this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserRoleDecision();

}

class _UserRoleDecision extends State<UserRoleDecision> {

  UserRoleBloc userRoleBloc = new UserRoleBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userRoleBloc.loadUserAdmin(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: userRoleBloc.adminUserStream,
      initialData: null,
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return LoadingIcon();
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getTitle(snapshot.data!),
              getAdminRoleToggle(snapshot.data!),
              getAnnonceRoleToggle(snapshot.data!),
              getMarketplaceRoleToggle(snapshot.data!),
            ],
          );
        }
      },
    );
  }

  getTitle(User user) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Text(
        "Id: ${user.id}, ${user.firstName} ${user.lastName} (${user.phone})",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      ),
    );
  }

  getAdminRoleToggle(User user) {
    return !AdminChecker.isAdminMonitor(user)
    ? BigButton(
      background: lightGreen,
      text: Text("Rôle Gestion administrateirs"),
      icon: Icon(Icons.add),
      callback: () {
        userRoleBloc.updateAdminRole(user.id!, true);
      },
    )
    : BigButton(
      background: lightRed,
      text: Text("Rôle Gestion administrateirs"),
      icon: Icon(Icons.remove),
      callback: () {
        userRoleBloc.updateAdminRole(user.id!, false);
      },
    );
  }

  getAnnonceRoleToggle(User user) {
    return !AdminChecker.isAnnonceMonitor(user)
    ? BigButton(
      background: lightGreen,
      text: Text("Gestion des annonces"),
      icon: Icon(Icons.add),
      callback: () {
        userRoleBloc.updateAnnonceRole(user.id!, true);
      },
    )
    : BigButton(
      background: lightRed,
      text: Text("Gestion des annonces"),
      icon: Icon(Icons.remove),
      callback: () {
        userRoleBloc.updateAnnonceRole(user.id!, false);
      },
    );
  }

  getMarketplaceRoleToggle(User user) {
    return !AdminChecker.isMarketplaceMonitor(user)
    ? BigButton(
      background: lightGreen,
      text: Text("Gestion des annonceurs"),
      icon: Icon(Icons.add),
      callback: () {
        userRoleBloc.updateAnnonceurRole(user.id!, true);
      },
    )
    : BigButton(
      background: lightRed,
      text: Text("Gestion des annonceurs"),
      icon: Icon(Icons.remove),
      callback: () {
        userRoleBloc.updateAnnonceurRole(user.id!, false);
      },
    );
  }

}