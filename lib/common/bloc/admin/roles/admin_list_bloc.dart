import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/monitoring_service.dart';
import 'package:mobile_frontend/constraints.dart';

class AdminListBloc implements Bloc {

  final adminListPipeline = StreamController<List<User>?>.broadcast();
  Sink   <List<User>?> get adminListSink   => adminListPipeline.sink;
  Stream <List<User>?> get adminListStream => adminListPipeline.stream;

  final errorPipeline = StreamController<String?>.broadcast();
  Sink   <String?> get errorSink   => errorPipeline.sink;
  Stream <String?> get errorStream => errorPipeline.stream;

  Future<void> addRoleToUser(int userId, bool admiNRole, bool annonceRole, bool annonceurRole) async {
    try {

      if(admiNRole)     await MonitoringService.toggleAdminRole(userId, true);
      if(annonceRole)   await MonitoringService.toggleAnnonceRole(userId, true);
      if(annonceurRole) await MonitoringService.toggleAnnonceurRole(userId, true);
      this.loadAdminList();

    } on WaneBackException catch(e) {

    } catch (e, stacktrace) {

    }
  }

  Future<void> loadAdminList() async {
    adminListSink.add(null);
    errorSink.add(null);
    print("loadAdminList()");

    try {

      List<User>? adminList = await MonitoringService.getAdminList();
      print("length: ${adminList!.length}");
      adminListSink.add(adminList);

    } on WaneBackException catch(e) {
      inspect(e.message);
      errorSink.add(null);
      errorSink.add(e.message);
    } catch (e, stacktrace) {
      inspect(e);
      inspect(stacktrace);
      errorSink.add(INTERNAL_ERROR_MESSAGE);
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    adminListPipeline.close();
  }

  // singleton
  // static final AdminListBloc _instance = AdminListBloc._internal();
  // factory AdminListBloc () => _instance;
  // AdminListBloc._internal();

}
//
// AdminListBloc adminListBloc = AdminListBloc();