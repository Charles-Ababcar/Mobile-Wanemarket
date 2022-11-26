import 'package:mobile_frontend/common/classes/user.dart';

class AdminChecker {


  static bool isAdminMonitor(User user) {
    bool isAdmin = user.roles!.where((element) => element.name == "ROLE_APP_OWNER")
        .toList()
        .length > 0;
    return isAdmin;
  }

  static bool isAnnonceMonitor(User user) {
    bool isAdmin = user.roles!.where((element) => element.name == "ROLE_ANNONCE_MONITORING")
        .toList()
        .length > 0;
    return isAdmin;
  }

  static bool isMarketplaceMonitor(User user) {
    bool isAdmin = user.roles!.where((element) => element.name == "ROLE_MARKETPLACE_MONITORING")
        .toList()
        .length > 0;
    return isAdmin;
  }


}