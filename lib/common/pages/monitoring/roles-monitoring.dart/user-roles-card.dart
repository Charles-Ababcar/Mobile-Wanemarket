import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/admin/roles/user_role_bloc.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/customed-widgets/admin/user-roles-decisions/dart/user-role-decision.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';

import '../../../../constraints.dart';

class UserMonitoringCard extends StatefulWidget {

  final int userId;
  const UserMonitoringCard({Key? key, required this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserMonitoringCard();
  
}

class _UserMonitoringCard extends State<UserMonitoringCard> {

  UserRoleBloc userRoleBloc = new UserRoleBloc();

  Color buttonValidatedAction = lightGrey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userRoleBloc.loadUserAdmin(widget.userId);
  }

  @override
  Widget build(Object context) {
    Size size = MediaQuery.of(context as BuildContext).size;

    // TODO: implement build
    return StreamBuilder<User?>(
      stream: userRoleBloc.adminUserStream,
      initialData: null,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return GestureDetector(
            child: getAdminCard(snapshot.data!, size),
            onTap: () {
              showAdminDetail(snapshot.data!);
            },
          );
        } else {
          return LoadingIcon();
        }
      },
    );
  }

  getAdminCard(User user, Size size) {

    return Container(

      height: 50,
      width: size.width,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),

      decoration: BoxDecoration(
          color: yellowSemi,
          borderRadius: new BorderRadius.all(const Radius.circular(15.0))
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          Text(getUserTextProfil(user),
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300
            ),
          ),

        ]
      )

    );
  }

  getUserTextProfil(User user) {
    return "${user.firstName} ${user.lastName!.toUpperCase()}";
  }

  showAdminDetail(User user) {
    Popup.modal(context, UserRoleDecision(userId: user.id!));
  }

}