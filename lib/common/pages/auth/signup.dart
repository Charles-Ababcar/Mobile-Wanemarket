import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/bloc/auth_bloc.dart';
import 'package:mobile_frontend/common/bloc/cities_bloc.dart';
import 'package:mobile_frontend/common/bloc/signup_bloc.dart';
import 'package:mobile_frontend/common/classes/city.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/material/dropdown.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';


// wane-material
import 'package:mobile_frontend/common/material/textfield.dart';
import 'package:mobile_frontend/common/material/main-button.dart';
import 'package:mobile_frontend/common/pages/information/welcoming.dart';
import 'package:mobile_frontend/constraints.dart';

// compoenents 
import 'package:mobile_frontend/common/customed-widgets/custom-scrollable.dart';

import 'edit_profile.dart';

class SignupWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupWidget();  
}

class _SignupWidget extends State<SignupWidget> {

  /**
   * 
   */
  final signupBloc = new SignupBloc();

  /**
   * 
   */
  final citiesBloc = new CitiesBloc();

  /**
   * form
   */
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  /**
   * data
   */
  User userToAdd = new User("", "");
  int? userCity;

  @override
  void dispose() {
    super.dispose();
    citiesBloc.dispose();
    signupBloc.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    citiesBloc.loadCities();
  }
  
  @override
  Widget build(BuildContext context) {
    

   Size size = MediaQuery.of(context).size;
   return Material(
    child: Container(

      child: Column(
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
            child: CustomScrollable (
              child: Form (
                key: _formKey,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
                  children: <Widget>[

                    /**
                     * showing form request error
                     */
                    errorMessageStream(),

                    /** 
                     * TextField phone
                     */
                    phoneFormField(),


                    SizedBox(height: sizedBoxHeight), 

                    /** 
                     * TextField firstname
                     */
                    firstNameFormField(),
                    

                    SizedBox(height: sizedBoxHeight), 

                    /** 
                     * TextField name
                     */
                    lastNameFormField(),

                    SizedBox(height: sizedBoxHeight),

                    /** 
                     * Adresse name
                     */
                    addressFormField(),

                    SizedBox(height: sizedBoxHeight),


                    /** 
                     * TextField city
                     */
                    cityFormField(),

                    SizedBox(height: sizedBoxHeight),
                    Divider(color: yellowStrong),
                    SizedBox(height: sizedBoxHeight), 

                    /** 
                     * TextField password
                     */
                    passwordFormField(),

                    SizedBox(height: sizedBoxHeight), 

                    /** 
                     * TextField repeat
                     */
                    repeatPasswordFormField(),

                    SizedBox(height: sizedBoxHeight), 

                    /**
                     * connection button
                     */
                    sendingButton(),

                    SizedBox(height: sizedBoxHeight), 

                    /**
                     * if is created
                     */
                    isCreatedStream(),

                  ]
                )

              ) 
            )
          )
              
        ],

      ),

    ) 
   );
  }

  ////////////////////////////////
  ///////// FORM FIELDS   ////////
  ////////////////////////////////

  ///
  /// Phone form field
  ///
  Widget phoneFormField() {
    return TextFieldContainer(
      textFieldHintText: "N°téléphone",
      customedIcon: Icon(Icons.phone, size: 20),
      maxLength: 15,
      
      onValidate: (Object? value) {
        if(value.toString().isEmpty) {
          return "Le N° de téléphone est requis";
        }
        return "";
      },

      onSave: (Object? value) {
        userToAdd.phone = value.toString();
      },
      
    );
  }


  ///
  /// Phone form field
  ///
  Widget firstNameFormField() {
    return TextFieldContainer(
      textFieldHintText: "Prénom",
      customedIcon: Icon(Icons.person, size: 20),
      maxLength: 50,
      
      onValidate: (Object? value) {
        if(value.toString().isEmpty) {
          return "Le prénom est requis";
        }
        return "";
      },

      onSave: (Object? value) {
        userToAdd.firstName = value.toString();
      },
      
    );
  }

  ///
  /// Phone form field
  ///
  Widget lastNameFormField() {
    return  TextFieldContainer(
      textFieldHintText: "Nom",
      customedIcon: Icon(Icons.person, size: 20),
      maxLength: 50,
      
      onValidate: (Object? value) {
        if(value.toString().isEmpty) {
          return "Le champs nom est requis";
        }
        return "";
      },

      onSave: (Object? value) {
        userToAdd.lastName = value.toString();
      }
    );
  }

  ///
  /// Phone form field
  ///
  Widget addressFormField() {
    return  TextFieldContainer(
      textFieldHintText: "Adresse",
      customedIcon: Icon(Icons.add_location_rounded, size: 20),
      maxLength: 100,
      
      onValidate: (Object? value) {
        print("taille '$value'");
        if(value.toString().isEmpty) {
          return "Le champs adresse est requis";
        }
        return "";
      },

      onSave: (Object? value) {
        userToAdd.address = value.toString();
      }
    );
  }


  ///
  /// Phone form field
  ///
  Widget cityFormField() {

    return StreamBuilder<List<City>?> (
      stream: citiesBloc.stream,
      initialData: null,
      builder: (context, snapshot) {

        if(!snapshot.hasData || snapshot.data == null) {
          return LoadingIcon();
        } else {

          List<City>? cities = snapshot.data;
          userCity = cities![0].id;

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

                items: cities.map<DropdownMenuItem<String>>((City city) {
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

  ///
  /// Phone form field
  ///
  Widget passwordFormField() {
    return TextFieldContainer(
      textFieldHintText: "Mot de passe",
      isPassword: true,
      customedIcon: Icon(Icons.lock, size: 20),
      maxLength: 50,
      
      onValidate: (Object? value) {
        if(value.toString().isEmpty) {
          return "Le mot de passe est requis";
        }
        return "";
      },

      onSave: (Object? value) {
        userToAdd.password = value.toString();
      },
      
    );
  }


  ///
  /// Phone form field
  ///
  Widget repeatPasswordFormField() {
    return TextFieldContainer(
      textFieldHintText: "Répétez le mot de passe",
      isPassword: true,
      customedIcon: Icon(Icons.lock, size: 20),
      maxLength: 50,
      
      onValidate: (Object? value) {
        if(value.toString().isEmpty) {
          return "Veuillez répéter le mot de passe";
        }
        return "";
      },

      onSave: (Object? value) {
        userToAdd.repeatPassword = value.toString();
      },
                            
    );
  }


  ///
  /// Sending button
  ///
  Widget sendingButton() {
    return MainButton(
      buttonText: "Enregistrer",
      onPressed: () async {

        print("cityId: ${userCity}");


        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          print("cityId: ${userCity}");
          City city = new City(userCity, null, null);
          userToAdd.city = city;

          bool isSigned = await signupBloc.signup(userToAdd);

          /**
           * avoid poping is sign didnt work
           */
          if(isSigned) {

            if(applicationState.cguValidated) {
              await authBloc.authenticate(userToAdd.phone, userToAdd.password);
            } else {
              Navigator.push(context, new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return SignupWelcom(callback: () {
                      authBloc.authenticate(userToAdd.phone, userToAdd.password);
                      Navigator.of(context).pop();
                    },);
                  }
              ));
            }
            //Navigator.pop(context);
          }
          
        }
      },  
    );    
  }


  ////////////////////////////////
  ///   ERROR MESSAGE STREAM   ///
  ////////////////////////////////


  ///
  /// error message stream
  ///
  StreamBuilder<String?> errorMessageStream() {
    return StreamBuilder<String?> (
      stream: signupBloc.reqErrStream,
      initialData: null,
      builder: (context, snapshot) {

        // si rien, affiche rien 
        if(snapshot.data == null) {
            return Container();
        } else if(snapshot.hasData) {
          return Column (
            children: [
              /**
               * request errorù
               */
              SizedBox(height: sizedBoxHeight),

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
          return Container();
        }
      }
    );
  }

  ///
  /// is created message stream
  ///
  StreamBuilder<bool> isCreatedStream() {
    return StreamBuilder<bool> (
      stream: signupBloc.isCreatedStream,
      initialData: false,
      builder: (context, snapshot) {

        // si rien, affiche rien 
        if(snapshot.data == null) {
            return Container();
        } else if(snapshot.hasData) {
            if(snapshot.data == true) {
              return LoadingIcon();
            } else {
              return new Container();
            }
        } else {
          return new Container();
        }
      }
    );  
  }

}