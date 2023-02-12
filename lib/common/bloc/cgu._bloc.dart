import 'dart:async';
import 'dart:developer';

import 'bloc.dart';
import 'package:flutter/services.dart' show rootBundle;


class CGUBloc implements Bloc {

  final _streamController = StreamController<List<String>?>.broadcast();
  Sink  <List<String>?> get sink   => _streamController.sink;
  Stream<List<String>?> get stream => _streamController.stream;

  Future<void> loadCgu() async {
    sink.add(null);
    try {
      List<String> cgu = [];

      cgu.add(await getContent("cgu/art1.txt"));
      cgu.add(await getContent("cgu/art2.txt"));
      cgu.add(await getContent("cgu/art3.txt"));
      cgu.add(await getContent("cgu/art3bis.txt"));
      cgu.add(await getContent("cgu/art4.txt"));
      cgu.add(await getContent("cgu/art5.txt"));
      cgu.add(await getContent("cgu/art6.txt"));
      cgu.add(await getContent("cgu/art7.txt"));
      cgu.add(await getContent("cgu/art8.txt"));
      cgu.add(await getContent("cgu/art9.txt"));
      cgu.add(await getContent("cgu/art10.txt"));
      cgu.add(await getContent("cgu/art11.txt"));
      cgu.add(await getContent("cgu/art12.txt"));

      sink.add(cgu);
    } catch (e, stacktrace) {
      print("error ${e}");
      inspect(e);
    }
  }

  Future<String> getContent(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamController.close();
  }



}