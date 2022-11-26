import 'dart:async';
import 'dart:developer';

import 'package:mobile_frontend/common/bloc/bloc.dart';
import 'package:mobile_frontend/common/classes/marketplace.dart';
import 'package:mobile_frontend/common/classes/user.dart';
import 'package:mobile_frontend/common/exception/wane_exception.dart';
import 'package:mobile_frontend/common/services/back-end/monitoring_service.dart';
import 'package:mobile_frontend/constraints.dart';

class MarketplaceListBloc implements Bloc {

  final marketplaceListPipeline = StreamController<List<Marketplace>?>.broadcast();
  Sink   <List<Marketplace>?> get marketplaceListSink   => marketplaceListPipeline.sink;
  Stream <List<Marketplace>?> get marketplaceListStream => marketplaceListPipeline.stream;

  final errorPipeline = StreamController<String?>.broadcast();
  Sink   <String?> get errorSink   => errorPipeline.sink;
  Stream <String?> get errorStream => errorPipeline.stream;

  static Future<void> marketplaceDecision(int marketplaceId, bool decision) async {

    try {

      await MonitoringService.annonceurDecision(marketplaceId, decision);

      // this.loadMarketplaceList();
    } on WaneBackException catch(e) {
      inspect(e.message);
    } catch (e, stacktrace) {
      inspect(e);
      inspect(stacktrace);
    }

  }

  Future<void> loadMarketplaceList() async {
    marketplaceListSink.add(null);
    errorSink.add(null);

    try {

      List<Marketplace>? annonceursList = await MonitoringService.getMarketplaceList();
      marketplaceListSink.add(annonceursList);

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
    marketplaceListPipeline.close();
  }

}