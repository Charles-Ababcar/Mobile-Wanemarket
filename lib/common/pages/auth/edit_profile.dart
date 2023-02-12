import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/bloc/cities_bloc.dart';
import 'package:mobile_frontend/common/bloc/profile_edit_bloc.dart';
import 'package:mobile_frontend/common/bloc/user_data_bloc.dart';
import 'package:mobile_frontend/common/classes/city.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/material/dropdown.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/bloc/auth_bloc.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';


// wane-material
import 'package:mobile_frontend/common/material/textfield.dart';
import 'package:mobile_frontend/common/material/main-button.dart';
import 'package:mobile_frontend/constraints.dart';

// compoenents 
import 'package:mobile_frontend/common/customed-widgets/custom-scrollable.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditProfilePage();
  
}

class _EditProfilePage extends State<EditProfilePage>{

  /**
   * 
   */
  final editBloc = new ProfileEditBloc();

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
  User? userToEdit = applicationState.authUser;
  int?  userCity = applicationState.authUser!.city!.id;

  @override
  void dispose() {
    super.dispose();
    citiesBloc.dispose();
    editBloc.dispose();
  }

  @override 
  void initState() {
    print("user city: ${userCity}");
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
                     * TextField name
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
                    confirmCurrentPasswordField(),

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

                    StreamBuilder<bool?> (
                      stream: editBloc.loadingStream,
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
                    )


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
  Widget firstNameFormField() {
    return TextFieldContainer(
      textFieldHintText: "Prénom",
      customedIcon: Icon(Icons.person, size: 20),
      initialValue: userToEdit!.firstName,
      maxLength: 50,
      
      onValidate: (Object? value) {
        if(value.toString().isEmpty) {
          return "Le prénom est requis";
        }
        return "";
      },

      onSave: (Object? value) {
        userToEdit!.firstName = value.toString();
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
      initialValue:  userToEdit!.lastName,
      maxLength: 50,
      
      onValidate: (Object? value) {
        if(value.toString().isEmpty) {
          return "Le champs nom est requis";
        }
        return "";
      },

      onSave: (Object? value) {
        userToEdit!.lastName = value.toString();
      }
    );
  }

  ///
  /// Phone form field
  ///
  Widget addressFormField() {
    return  TextFieldContainer(
      textFieldHintText: "Adresse",
      customedIcon: Icon(Icons.person, size: 20),
      initialValue: userToEdit!.address,
      maxLength: 100,
      
      onValidate: (Object? value) {
        if(value.toString().isEmpty) {
          return "Le champs adresse est requis";
        }
        return "";
      },

      onSave: (Object? value) {
        userToEdit!.address = value.toString();
      }
    );
  }


  ///
  /// Phone form field
  ///
  // Widget cityFormField() {
  //   return Row(
  //     children: [
  //       Dropdown(
  //         pickedValue: userCity.toString(),
                                    
  //         whenOnChange: (String newValue) {
  //           setState(() {
  //             userCity = int.parse(newValue);
  //           });
  //         },

  //         items: City.getCities().map<DropdownMenuItem<String>>((City city) {
  //           return DropdownMenuItem<String>(
  //             value: city.id.toString(),
  //             child: Text(city.title!),
  //           );
  //         }).toList(),
  //       ),
  //   ]);
  // }
  Widget cityFormField() {

    return StreamBuilder<List<City>?> (
      stream: citiesBloc.stream,
      initialData: null,
      builder: (context, snapshot) {

        if(!snapshot.hasData || snapshot.data == null) {
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


  ///
  /// Phone form field
  ///
  Widget passwordFormField() {
    return TextFieldContainer(
      textFieldHintText: "Nouveau mot de passe",
      isPassword: true,
      customedIcon: Icon(Icons.lock, size: 20),
      maxLength: 15,
      
      onValidate: (Object? value) {
        return "";
      },

      onSave: (Object? value) {
        userToEdit!.password = value.toString();
      },
      
    );
  }


  ///
  /// Phone form field
  ///
  Widget repeatPasswordFormField() {
    return TextFieldContainer(
      textFieldHintText: "Répétez le nouveau mot de passe",
      isPassword: true,
      customedIcon: Icon(Icons.lock, size: 20),
      maxLength: 15,
      
      onValidate: (Object? value) {
        return "";
      },

      onSave: (Object? value) {
        userToEdit!.repeatPassword = value.toString();
      },
                            
    );
  }

  ///
  /// COnfirm password field
  ///
  Widget confirmCurrentPasswordField() {
    return TextFieldContainer(
      textFieldHintText: "Ancien mot de passe",
      isPassword: true,
      customedIcon: Icon(Icons.lock, size: 20),
      maxLength: 15,
      
      onValidate: (Object? value) {
        return "";
      },

      onSave: (Object? value) {
        userToEdit!.confirmCurrentPassword = value.toString();
      },
                            
    );
  }


  ///
  /// Sending button"user/update"
  ///
  Widget sendingButton() {
    return MainButton(
      buttonText: "Enregistrer",
      onPressed: () async {

        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          City city = new City(userCity, null, null);
          userToEdit!.city = city;
          userToEdit!.phone = applicationState.authUser!.phone;

          bool isUpdated = await editBloc.updateUser(userToEdit!);

          print("phone ${userToEdit!.phone}");
        
          /**
           * avoid poping is sign didnt work
           */
          if(isUpdated) {
            userDataBloc.loadUserFromRemote();
            await Future.delayed(Duration(microseconds: 200));
            Navigator.pop(context);
          }
          
        }
      },  
    );    
  }

  ////////////////////////////////
  /// ERROR MESSAGE STREAM     ///
  ////////////////////////////////

  ///
  /// error message stream
  ///
  StreamBuilder<String?> errorMessageStream() {
    return StreamBuilder<String?> (
      stream: editBloc.requestErrorstream,
      initialData: "",
      builder: (context, snapshot) {

        // si rien, affiche rien 
        if(snapshot.hasData){
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
          return new Container();
        }
      }
    );
  }

}