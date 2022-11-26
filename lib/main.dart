import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-visitor-scaffold.dart';
import 'package:mobile_frontend/common/pages/home/home-visitor.dart';
import 'application_state.dart';
import 'common/bloc/auth_bloc.dart';
import 'common/classes/user.dart';
import 'common/customed-widgets/custom-connected-scaffold.dart';
import 'common/material/loading_icon.dart';
import 'common/pages/auth/auth.dart';
import 'common/pages/common/splash-screen.dart';
import 'common/pages/information/welcoming.dart';
import 'constraints.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {

  await WidgetsFlutterBinding.ensureInitialized();

  ///
  /// Initialize firebase
  ///
  await Firebase.initializeApp();

  ///
  /// init data from local
  ///
  await applicationState.init();

  ///
  /// init messaging to listen notifications
  ///
  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /**
     * RESTRICT TO PORTRAIT
     */
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Wanémarket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ThemeData()
            .colorScheme
            .copyWith(primary: yellowStrong, secondary: yellowStrong),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Apollo',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /**
     * first page is LoginPage
     */
    return appRedirection();
  }

  appRedirection() {
    return StreamBuilder<bool?>(
        stream: authBloc.authStream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            ///
            /// check if token auth is valid
            ///
            authBloc.init();

            print("------------ LOADING ------------");
            return Material(
                child: Container(
              child: Center(
                child: LoadingIcon(),
              ),
            ));
          } else {
            if (snapshot.data! == false) {
              print("------------ AUTH PAGE ------------");
              return Material(
                  // child: AuthPage(),
                  child: ScaffoldConnectedCustom());
            } else {
              print("------------ WELCOM PAGE ------------");
              return ScaffoldConnectedCustom();
            }
          }
        });
  }
}
