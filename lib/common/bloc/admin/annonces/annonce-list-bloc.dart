import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/monitoring_service.dart';
import 'package:mobile_frontend/constraints.dart';

class AnnonceListBloc implements Bloc {

  final itemListPipeline = StreamController<List<Item>?>.broadcast();
  Sink   <List<Item>?> get itemListSink   => itemListPipeline.sink;
  Stream <List<Item>?> get itemListStream => itemListPipeline.stream;

  final errorPipeline = StreamController<String?>.broadcast();
  Sink   <String?> get errorSink   => errorPipeline.sink;
  Stream <String?> get errorStream => errorPipeline.stream;

  static Future<void> annonceDecision(int annonceId, bool decision) async {

    try {

      await MonitoringService.annonceDecision(annonceId, decision);

      // this.loadMarketplaceList();
    } on WaneBackException catch(e) {
      inspect(e.message);
    } catch (e, stacktrace) {
      inspect(e);
      inspect(stacktrace);
    }

  }

  Future<void> loadAnnonceList() async {
    itemListSink.add(null);
    errorSink.add(null);

    try {

      List<Item>? annoncesList = await MonitoringService.getAnnonceList();
      itemListSink.add(annoncesList);

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
    itemListPipeline.close();
  }

}