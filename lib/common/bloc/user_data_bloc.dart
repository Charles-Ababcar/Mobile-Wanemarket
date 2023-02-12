
import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/services/back-end/auth_service.dart';

class UserDataBloc implements Bloc {

  final _userStream = StreamController<User?> .broadcast();

  Sink   <User?> get userSink => _userStream.sink;
  Stream <User?> get userStream => _userStream.stream;


  void loadUserFromSession() {
    userSink.add(applicationState.authUser);
  }

  Future<void> loadUserFromRemote() async {
    User user = await AuthService.getInfos();
    userSink.add(user);
  }


  @override
  void dispose() {
    _userStream.close();
  }

  // singleton
  static final UserDataBloc _instance = UserDataBloc._internal();
  factory UserDataBloc() {
    return _instance;
  }
  UserDataBloc._internal();
}

UserDataBloc userDataBloc = UserDataBloc();