import 'package:flutter/material.dart';
import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/cgu.dart';
import 'package:mobile_frontend/common/bloc/cgu._bloc.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-connected-scaffold.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-scrollable.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/material/main-button.dart';
import 'package:mobile_frontend/constraints.dart';
import 'package:flutter/services.dart' show rootBundle;

class SignupWelcom extends StatefulWidget {

  // User? user = applicationState.authUser;
  final void Function()? callback;
  const SignupWelcom({super.key, this.callback});

  @override
  State<StatefulWidget> createState() => _SignupWelcom();

}

class _SignupWelcom extends State<SignupWelcom> {

  CGUBloc cguBloc = new CGUBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cguBloc.loadCgu();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cguBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
   Size size = MediaQuery.of(context).size;

   return Material(
      color: yellowLight,
      child: StreamBuilder<List<String>?>(
        initialData: null,
        stream: cguBloc.stream,
        builder: (context, snapshot) {
          if(snapshot.data == null) {
            return LoadingIcon();
          } else {
            return Stack(
              children: [
                getCGUPage(snapshot.data),

                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: getButton(),
                )
              ],
            );
          }
        },
      )
   );
  }

  getCGUPage(cgu) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 50),
        child:  CustomScrollable(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Image.asset("images/wanemarket_logo.png", height: 50),
              ),

              Text("Conditions Générales d'Utilisation et de Ventes", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25
              ),),

              getTitle(cgu_art1_title),
              getContent(cgu[0]),

              getTitle(cgu_art2_title),
              getContent(cgu[1]),

              getTitle(cgu_art3_title),
              getContent(cgu[2]),

              getTitle(cgu_art3bis_title),
              getContent(cgu[3]),

              getTitle(cgu_art4_title),
              getContent(cgu[4]),

              getTitle(cgu_art5_title),
              getContent(cgu[5]),

              getTitle(cgu_art6_title),
              getContent(cgu[6]),

              getTitle(cgu_art7_title),
              getContent(cgu[7]),

              getTitle(cgu_art8_title),
              getContent(cgu[8]),

              getTitle(cgu_art9_title),
              getContent(cgu[9]),

              getTitle(cgu_art10_title),
              getContent(cgu[10]),

              getTitle(cgu_art11_title),
              getContent(cgu[11]),

              getTitle(cgu_art12_title),
              getContent(cgu[12]),

              SizedBox(height: sizedBoxHeight,),

              SizedBox(height: 30,),


            ],
          ),
        )
    );
  }

  getTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 30),
      child: Text(title, style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
      ),),
    );
  }

   Widget getContent(String txt) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 30),
      child: Text(txt, style: TextStyle(
          fontSize: 18
      ),),
    );
  }

  Widget getButton() {
    return BigButton(
      icon: Icon(Icons.check),
      background: yellowSemi,
      text: Text( "J'accepte et je confirme"),
      callback: () async {
        await applicationState.validatedCGU();

        if(widget.callback != null) {
          widget.callback!();
        } else {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              ScaffoldConnectedCustom()), (Route<dynamic> route) => false);
        }
      },
    );
  }

}