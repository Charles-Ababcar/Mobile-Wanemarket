import 'dart:io';

import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_frontend/common/bloc/cities_bloc.dart';
import 'package:mobile_frontend/common/bloc/marketplace_bloc.dart';
import 'package:mobile_frontend/common/classes/city.dart';
import 'package:mobile_frontend/common/classes/marketplace.dart';
import 'package:mobile_frontend/common/material/dropdown.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/material/round-button.dart';
import 'package:mobile_frontend/common/material/textarea.dart';

// wane-material
import 'package:mobile_frontend/common/material/textfield.dart';
import 'package:mobile_frontend/common/material/main-button.dart';

// compoenents
import 'package:mobile_frontend/common/customed-widgets/custom-scrollable.dart';
import 'package:mobile_frontend/application_state.dart';

import '../../../constraints.dart';

class MarketPlaceFormWidget extends StatefulWidget {
  const MarketPlaceFormWidget({Key? key}) : super(key: key);

  @override
  _MarketPlaceFormWidget createState() => _MarketPlaceFormWidget();
}

class _MarketPlaceFormWidget extends State<MarketPlaceFormWidget> {

  // form stuff
  Marketplace marketplace = new Marketplace();
  int? userCity = applicationState.authUser!.city!.id;
  String? addr = applicationState.authUser!.address;
  bool isSameAddress = true;

  /**
   * form
   */
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  /**
   * bloc
   */
  final MarketplaceBloc marketplaceBloc = new MarketplaceBloc();

  /**
   *  cities
   */
  final CitiesBloc citiesBloc = new CitiesBloc();


  @override
  void dispose() {
    super.dispose();
    citiesBloc.dispose();
    marketplaceBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    citiesBloc.loadCities();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return new Material(
         
      child: StreamBuilder<bool?> (
        stream: marketplaceBloc.successRequestStream,
        initialData: false,
        builder: (context, snapshot) {
 
          if(snapshot.data == false) {
            return globalForm(size); 
          } else {
            return successForm(size);
          }

        },
      ),
    );
  }


  // -------------------------------------------------------------------
  //                         WHEN FEEDING FORM
  // -------------------------------------------------------------------

  Widget globalForm(Size size) {
    return Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /**
           * container input
           */
          Container(
            padding: EdgeInsets.only(top: 50),
            height: size.height * 1,
            width: size.width * 0.9,

            /**
             * column including inputs
             */
            child: CustomScrollable(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //Center Column contents hor,izontally,
                    children: <Widget>[

                      /**
                       * info container
                       */
                      theInfoContainer(),

                      SizedBox(height: sizedBoxHeight),

                      /**
                       * TextField email/phone
                       */
                      nameInput(),

                      SizedBox(height: sizedBoxHeight),
                      
                      /**
                       * textfield
                       */
                      phoneInput(),

                      SizedBox(height: sizedBoxHeight),

                      /**
                       * TextField adresse
                       */
                      addressInput(),

                      SizedBox(height: sizedBoxHeight),

                      /**
                       * dropdown city
                       */
                      cityDropdown(),

                      SizedBox(height: sizedBoxHeight),

                      /**
                       * description
                       */
                      descriptionInput(),

                      SizedBox(height: sizedBoxHeight), 
                      /**
                       * connection button
                       */
                      sendingButton(),

                      SizedBox(height: sizedBoxHeight),

                      loadingIcon(),

                    ],
                  ),
                )
            ),
          )
        ],
      ),
    );
  }

  // -------------------------------------------------------------------
  //                         WHEN SUCCESS FORM
  // -------------------------------------------------------------------

  Widget successForm(Size size) {
    return Container(
      height: size.height,
      width: size.width,

      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [
            InfoContainer(
              icon: Icon(
                Icons.beenhere_outlined,
                size: 40,
                color: yellowStrong,
              ),
              contentColor: yellowSemi,
              borderColor: yellowSemi,
              text: Text(
                "Wanémarket va étudier votre demande " +
                ", nous vous appellerons sûrement pour avoir des précisions. Une " +
                "fois votre demande validée, vous pourrez accéder aux fonctionnalités.",
                style: TextStyle()
              ),
            ),

            SizedBox(height: sizedBoxHeight),

            RoundButton(
              buttonColor: yellowSemi,
              icon: Icon(Icons.arrow_back, color: yellowStrong,),
              height: 50,
              width: 50,
              callback: () {
                Navigator.pop(context);
              },
            )
        ],
      ),
    );
  }

  // -------------------------------------------------------------------
  //                         SUB CONTENT
  // -------------------------------------------------------------------


  Widget theInfoContainer() {
    return StreamBuilder<String?> (
      stream: marketplaceBloc.loginErrorStream,
      initialData: null,
      builder: (context, snapshot) {
        
        if(snapshot.hasData) {
          return InfoContainer(
            icon: Icon(Icons.warning_amber_rounded, size: 40, color: Colors.red),
            contentColor: lightRed,
            borderColor: lightRed,
            height: 100,
            text: Text(snapshot.data.toString().toLowerCase(), style: TextStyle()),
          );
        } else {
          return InfoContainer(
            icon: Icon(
              Icons.info_rounded,
              size: 40,
              color: yellowStrong,
            ),
            contentColor: yellowSemi,
            borderColor: yellowSemi,
            text: Text(
                "Wanémarket vous offre la possibilité " +
                    "de créer votre espace annonceur pour vendre " +
                    "vos articles. Veuillez remplir ce " +
                    "formulaire, les administrateurs étudierons votre demande.",
                style: TextStyle()
            ),
          );
        }
      },
    );
  }


  Widget nameInput() {
    return TextFieldContainer(
      textFieldHintText: "Nom de société",
      customedIcon: Icon(
          Icons.wallet_membership, size: 20),
      maxLength: 15,
      //key: _formKey,
      onValidate: (Object? value) {
        if (value.toString().isEmpty) {
          return "Le champ nom est requis";
        }
        return "";
      },
      onSave: (Object? value) {
        marketplace.name = value.toString();
      }
    );
  }

  Widget phoneInput() {
    return TextFieldContainer(
      textFieldHintText: "N°Téléphone de la société",
      customedIcon: Icon(Icons.phone, size: 20),
      maxLength: 15,

      onValidate: (Object? value) {
        if(value.toString().isEmpty) {
          return "Saisir un n° de téléphone";
        }
        return "";
      },

      onSave: (Object? value) {
        marketplace.phone = value.toString();
      },

    );
  }

  Widget addressInput() {
    return TextFieldContainer(
      textFieldHintText: "Adresse",
      initialValue: addr,
      customedIcon: Icon(
          Icons.wallet_membership, size: 20),
      maxLength: 50,
      //key: _formKey,
      onValidate: (Object? value) {
        if (value.toString().isEmpty) {
          return "Le champ adresse est requis";
        }
        return "";
      },
      onSave: (Object? value) {
        marketplace.address = value.toString();
      }
    );
  }

  Widget cityDropdown() {
    return StreamBuilder<List<City>?> (
      stream: citiesBloc.stream,
      initialData: null,
      builder: (context, snapshot) {

        if(!snapshot.hasData || snapshot.data == null) {
          print("STREAM NO DATA");
          return LoadingIcon();
          
        } else {

          List<City>? cities = snapshot.data;

          return Row(
            children: [
              Dropdown(
                pickedValue: userCity.toString(),
                                          
                whenOnChange: (String newValue) {
                  setState(() {
                    
                    userCity = int.parse(newValue);
                  });
                  print ("city change: ${userCity}");
                },

                items: cities!.map<DropdownMenuItem<String>>((City city) {
                  return DropdownMenuItem<String>(
                    value: city.id.toString(),
                    child: Text(city.title!),
                  );
                }).toList(),
              ),
          ]);
        }
      }
    );
  }

  Widget descriptionInput() {
    return TextAreaContainer(
      textFieldHintText: "Description de vos activités (50 mots)",

        onValidate: (Object? value) {
          if(!value.toString().isEmpty && value.toString().length > 200) {
            return "La description ne doit pas dépasser 200 lettres";
          }
          return "";
        },

        onSave: (Object? value) {
          marketplace.description = value.toString();
        },
      );
  }

  Widget sendingButton() {
    return MainButton(
        buttonText: "Envoyer la demande",
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            City city = new City(userCity, null, null);
            marketplace.location = city;

            await marketplaceBloc.askForMarketplace(marketplace);
                                            
          }
        }
    );
  }

  Widget loadingIcon() {
    return StreamBuilder<bool?> (
      stream: marketplaceBloc.loadingStream,
      initialData: false,
      builder: (context, snapshot) {

        if(snapshot.hasData) {
          if(snapshot.data == true) {
            return LoadingIcon();
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      }
    );
  }
}
