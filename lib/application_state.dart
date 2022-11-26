import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import 'common/classes/user.dart';


// clas qui gère les données de session de l'application
class ApplicationState {

  User?   authUser = null;
  String? authToken = null;
  String? phone;

  bool isFirstConnection = false;

  ///
  /// IS ADMIN
  ///
  bool isAdminMonitor() {
    bool isAdmin = authUser!.roles!.where((element) => element.name == "ROLE_APP_OWNER")
        .toList()
        .length > 0;
    return isAdmin;
  }

  bool isAnnonceMonitor() {
    bool isAdmin = authUser!.roles!.where((element) => element.name == "ROLE_ANNONCE_MONITORING")
        .toList()
        .length > 0;
    return isAdmin;
  }

  bool isMarketplaceMonitor() {
    bool isAdmin = authUser!.roles!.where((element) => element.name == "ROLE_MARKETPLACE_MONITORING")
        .toList()
        .length > 0;
    return isAdmin;
  }

  ///
  /// load data from shared preferences
  ///
  Future<void> init() async {
    print("applicationState.init()");
    final prefs    = await SharedPreferences.getInstance();
    this.phone     = await prefs.getString("wanemarket_connection_phone");
    this.authToken = await prefs.getString("wanemarket_auth_token");
    print("applications state has init data phone: '${this.phone}' '${this.authToken}'");
  }

  ///
  ///
  ///
  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("wanemarket_auth_token", token);
    this.authToken = token;
    print("token stored '${applicationState.authToken} ${token}'");
  }

  storeUserFromJson(userData) async {
    final prefs = await SharedPreferences.getInstance();
    this.authUser = User.map(userData);
    await prefs.setString("wanemarket_connection_phone", this.authUser!.phone!);
    print("user stored '${applicationState.authToken}'");
  }

  markIfFirstInstallation() async {
    final prefs = await SharedPreferences.getInstance();
    String? connectionTraces = await prefs.getString("wanemarket_connection_trace");

    if(connectionTraces == null) { // first auth, we make a trace
      this.isFirstConnection = true;
      await prefs.setString("wanemarket_connection_trace", "First connection ${DateTime.now().toString()}");
    } else { // else, we do nothing
      this.isFirstConnection = false;
    }
    print("Is first connection '${this.isFirstConnection}'");
  }

  ///
  /// release session, delete token
  ///
  releaseSession() async {
    this.authUser = null;
    this.authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("wanemarket_auth_token");
    print("session released");
  }

  // singleton
  static final ApplicationState _instance = ApplicationState._internal();
  factory ApplicationState() {
    return _instance;
  }
  ApplicationState._internal();
}

ApplicationState applicationState = ApplicationState();