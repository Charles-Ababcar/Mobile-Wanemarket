import 'package:flutter/material.dart';
import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/bloc/auth_bloc.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-scrollable.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';

// colors
import 'package:mobile_frontend/constraints.dart';

// wane-material
import 'package:mobile_frontend/common/material/textfield.dart';
import 'package:mobile_frontend/common/material/main-button.dart';

class LoginWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginWidget();
}

class _LoginWidget extends State<LoginWidget> {
  /**
   * form
   */
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  /**
   * 
   */
  String? phone;
  String? foundPhone;
  String? password;

  @override
  void initState() {
    print("INIT STATE");
    super.initState();
    foundPhone = applicationState.phone;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Material(
        color: yellowLight,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /**
             * showing form request error
             */
              errorStream(),

              /**
             * wanemarket logo
             */
              Image.asset("images/wanemarket_logo.png",
                  height: size.height * 0.15),
              const SizedBox(
                height: 60,
                width: 60,
              ),

              /**
             * container input
             */
              Container(
                  height: size.height * 0.4,
                  width: size.width * 0.9,

                  /**
               * column including inputs
               */
                  child: CustomScrollable(
                      child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment
                          .center, //Center Column contents horizontally,
                      children: <Widget>[
                        /**
                     * TextField email/phone
                     */
                        phoneFormField(),
                        SizedBox(height: sizedBoxHeight),

                        /**
                     * TextField password
                     */
                        passwordFormField(),
                        SizedBox(height: sizedBoxHeight),

                        /**
                     * connection button
                     */
                        sendingButton(),
                        SizedBox(height: sizedBoxHeight),
                        StreamBuilder<bool?>(
                            stream: authBloc.loadingStream,
                            initialData: false,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data == true) {
                                  return LoadingIcon();
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            })
                      ],
                    ),
                  ))),
            ],
          ),
        ));
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
      customedIcon: Icon(Icons.phone_outlined, size: 20),
      initialValue: "${foundPhone == null ? '' : foundPhone}",
      // initialValue: "",
      maxLength: 15,

      onValidate: (Object? value) {
        if (value.toString().isEmpty) {
          return "Le N° de téléphone est requis";
        }
        return "";
      },

      onSave: (Object? value) {
        phone = value.toString();
      },
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
      initialValue: "",
      // initialValue: "",
      maxLength: 15,

      onValidate: (Object? value) {
        if (value.toString().isEmpty) {
          return "Le N° de téléphone est requis";
        }
        return "";
      },

      onSave: (Object? value) {
        password = value.toString();
      },
    );
  }

  ///
  /// Phone form field
  ///
  Widget sendingButton() {
    return MainButton(
        buttonText: "Connexion",
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            bool? auth = await authBloc.authenticate(phone, password);

            if (auth == true) {
              // Navigator.pop(context);
            }
          }
        });
  }

  ////////////////////////////////
  /// ERROR MESSAGE STREAM     ///
  ////////////////////////////////

  Widget errorStream() {
    return StreamBuilder<String?>(
        stream: authBloc.loginErrorStream,
        initialData: null,
        builder: (context, snapshot) {
          // si rien, affiche rien
          if (snapshot.data == null) {
            return Container();
          } else if (snapshot.hasData) {
            return Column(
              children: [
                /**
               * request errorù
               */
                SizedBox(height: sizedBoxHeight),
                InfoContainer(
                  icon: Icon(Icons.warning_amber_rounded,
                      size: 40, color: Colors.red),
                  contentColor: lightRed,
                  borderColor: lightRed,
                  height: 100,
                  text: Text(snapshot.data.toString().toLowerCase(),
                      style: TextStyle()),
                ),
                SizedBox(height: sizedBoxHeight),
              ],
            );
          } else {
            return new Container();
          }
        });
  }
}
