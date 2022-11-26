import 'package:mobile_frontend/common/classes/operation.dart';

class Solde {

  int? id;
  double? currentAmount;

  List<Operation>? operations;



  static Solde map(data) {
    Solde solde = new Solde();

    solde.id = data["solde"]["id"];
    solde.currentAmount = data["solde"]["currentAmount"];

    int opCount =  data["solde"]["operations"].length;

    solde.operations = [];
    for(int i = 0; i < opCount; ++i) {
      Operation operation = Operation.map(data["solde"]["operations"][i]);
      solde.operations!.add(operation);
    }

    return solde;
  }

}