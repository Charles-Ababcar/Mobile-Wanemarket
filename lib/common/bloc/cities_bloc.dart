
import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/city.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/services/back-end/cities_service.dart';

class CitiesBloc implements Bloc {


  List<City>? cities;

  final _streamController = StreamController<List<City>?>.broadcast();
  Sink  <List<City>?> get sink   => _streamController.sink;
  Stream<List<City>?> get stream => _streamController.stream;


  Future<void> loadCities() async {

    sink.add(null);

    try {

      //if(cities == null) {
      cities = await CitiesService.getCities();
      //}

      sink.add(cities);
    } catch (e, stacktrace) {
      inspect(e);
    }
    
  }

  @override
  void dispose() {
    _streamController.close();
  }

}
//   // singleton
//   static final CitiesBloc _instance = CitiesBloc._internal();
//   factory CitiesBloc () => _instance;
//   CitiesBloc._internal();
// }

// CitiesBloc citiesBloc = CitiesBloc();