
import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/category.dart';
import 'package:mobile_frontend/common/classes/city.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/services/back-end/category_service.dart';
import 'package:mobile_frontend/common/services/back-end/cities_service.dart';

class CategoriesBloc implements Bloc {

  List<Category>? categories;

  final _streamController = StreamController<List<Category>?>.broadcast();
  Sink  <List<Category>?> get sink   => _streamController.sink;
  Stream<List<Category>?> get stream => _streamController.stream;

  Future<List<Category>?> loadAllCategoriesSync() async {
    try {
      categories = await CategoryService.getCategories();
      return categories;
    } catch (e, stacktrace) {
      inspect(e);
    }

  }

  Future<void> loadAllCategories() async {

    sink.add(null);

    try {

      categories = await CategoryService.getCategories();

      sink.add(categories);
      print("categories ${categories?.length}");
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