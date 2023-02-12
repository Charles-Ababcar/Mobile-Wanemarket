import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/article/item_query_bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/material/empty-wave.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/material/textfield.dart';

import 'item-card-full.dart';

class ResearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ResearchPage();
}

class _ResearchPage extends State<ResearchPage> {

  /**
   * bloc
   */
  ItemQueryBloc bloc = new ItemQueryBloc();
  bool firstQueryDone = false;

  @override
  void initState() {
    super.initState();
  }

  @override 
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return new Container(
      height: size.height,
      width: size.width,
      child: Column(children: <Widget>[

        /**
         * Formulaire
         */
        Container(
          height: 50,
          width: size.width,
          child: TextFieldContainer(
            textFieldHintText: "Mots clés",
            customedIcon: Icon(Icons.search),

            onSubmit: (String? value) {

              if(value != null && value != "" && value.length > 0) {

                setState(() {
                  firstQueryDone = true;
                  bloc.query(value);                 
                });

              }

            },

          ),
        ),

        StreamBuilder< List<Item>? > (
          stream: bloc.stream,
          initialData: null,

          builder: (context, snapshot) {

            if(!snapshot.hasData || snapshot.data == null) {
              if(firstQueryDone) {    

                // loading button when clicking 
                return Expanded (
                  child: LoadingIcon(),
                );
              
              } else {

                // if first page with 0 click, show empty awve 
                return Expanded (
                  child: EmptyWave(
                    text: "Il est temps de faire les courses",
                    icon: Icons.shopping_basket,
                  ),
                );

              }

            } else {

              // data are found
              List<Item>? items = snapshot.data;

              return Expanded (
                child: ListView(
                scrollDirection: Axis.vertical,
                children: items!.map<Widget> ((item) {
                  return new ItemCardReseach(item);
                }).toList()
              ));

              // return Container();
            }

          },

        )

      ])
    );
  }

}
