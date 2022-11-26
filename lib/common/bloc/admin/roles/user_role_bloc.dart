import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/monitoring_service.dart';

class UserRoleBloc implements Bloc {

  final adminUserPipeline = StreamController<User?>.broadcast();
  Sink   <User?> get adminUserSink   => adminUserPipeline.sink;
  Stream <User?> get adminUserStream => adminUserPipeline.stream;

  Future<void> loadUserAdmin(int userId) async {
    adminUserSink.add(null);
    try {
      User user = await MonitoringService.findAdmin(userId);
      adminUserSink.add(user);
    } on WaneBackException catch(e) {
      inspect(e.message);
    } catch (e, stacktrace) {
      inspect(e);
    }
  }

  Future<void> updateAdminRole(int userId, bool value) async {
    try {
      await MonitoringService.toggleAdminRole(userId, value);
      this.loadUserAdmin(userId);
    } on WaneBackException catch(e) {
    } catch (e, stacktrace) {
    }
  }

  Future<void> updateAnnonceRole(int userId, bool value) async {
    try {
      await MonitoringService.toggleAnnonceRole(userId, value);
      this.loadUserAdmin(userId);
    } on WaneBackException catch(e) {
    } catch (e, stacktrace) {
    }
  }

  Future<void> updateAnnonceurRole(int userId, bool value) async {
    try {
      await MonitoringService.toggleAnnonceurRole(userId, value);
      this.loadUserAdmin(userId);
    } on WaneBackException catch(e) {
    } catch (e, stacktrace) {
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    adminUserPipeline.close();
  }

}