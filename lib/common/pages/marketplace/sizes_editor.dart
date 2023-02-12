import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/constraints.dart';

class ItemSizesEditor extends StatefulWidget {

  final Item? item;
  final void Function(Item item) callback;

  const ItemSizesEditor({Key? key, this.item, required this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemSizesEditor();
}

class _ItemSizesEditor extends State<ItemSizesEditor> {

  GlobalKey<FormState> _form = new GlobalKey<FormState>();

  Map<String, bool> possibleShoesSizes   = new SplayTreeMap();
  Map<String, bool> possibleClothesSizes = new SplayTreeMap();
  Map<String, bool> possibleColors       = new SplayTreeMap();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    possibleShoesSizes["36"] = false;
    possibleShoesSizes["37"] = false;
    possibleShoesSizes["38"] = false;
    possibleShoesSizes["39"] = false;
    possibleShoesSizes["40"] = false;
    possibleShoesSizes["41"] = false;
    possibleShoesSizes["42"] = false;
    possibleShoesSizes["43"] = false;
    possibleShoesSizes["44"] = false;
    possibleShoesSizes["45"] = false;

    possibleClothesSizes["XS"] = false;
    possibleClothesSizes["S"] = false;
    possibleClothesSizes["L"] = false;
    possibleClothesSizes["M"] = false;
    possibleClothesSizes["XL"] = false;
    possibleClothesSizes["XXL"] = false;
    possibleClothesSizes["XXXL"] = false;

    possibleColors["Gris"] = false;
    possibleColors["Taupe"] = false;
    possibleColors["Beige"] = false;
    possibleColors["Blanc"] = false;
    possibleColors["Blanc cassé"] = false;
    possibleColors["Rouge"] = false;
    possibleColors["Noir"] = false;
    possibleColors["Marron"] = false;
    possibleColors["Rose"] = false;
    possibleColors["Mauve"] = false;
    possibleColors["Kaki"] = false;
    possibleColors["Bleu foncé"] = false;
    possibleColors["Prune"] = false;
    possibleColors["Fuschia"] = false;

    // save state

    widget.item!.shoesSizeAvailable.forEach((element) {
      possibleShoesSizes [element] = true;
    });


    widget.item!.clothesSizedAvailable.forEach((element) {
      possibleClothesSizes [element] = true;
    });


    widget.item!.colorsAvailable.forEach((element) {
      possibleColors [element] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Form(
            key: _form,
            child: Padding(
              padding: EdgeInsets.only(top: 60, left: 10, right: 10, bottom: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  getLabel("Taille de chaussures disponibles"),
                  getShoesSizeCheckbox(),
                  SizedBox(height: sizedBoxHeight),

                  getLabel("Taille d'habits disponibles"),
                  getClothesSizeCheckbox(),
                  SizedBox(height: sizedBoxHeight),

                  getLabel("Couleurs disponibles"),
                  getColorsCheckbox(),
                  SizedBox(height: sizedBoxHeight),

                ],
              ),
            )
          ),

          // validation button
          validateButton(),
        ],
      )
    );
  }

  getShoesSizeCheckbox() {
    List<String> keys = possibleShoesSizes.keys.toList(growable: false);

    return Expanded(child: new ListView(
      children: keys.map((String key) {
        return CheckboxListTile(
          activeColor: yellowStrong,
          title: Text(key),
          value: possibleShoesSizes[key],
          onChanged: (bool? value) {
            setState(() {
              possibleShoesSizes[key] = value!;
            });
          },
        );
      }).toList(),)
    );
  }

  getClothesSizeCheckbox() {
    List<String> keys = possibleClothesSizes.keys.toList(growable: false);

    return Expanded(child: new ListView(
      children: keys.map((String key) {
        return CheckboxListTile(
          activeColor: yellowStrong,
          title: Text(key),
          value: possibleClothesSizes[key],
          onChanged: (bool? value) {
            setState(() {
              possibleClothesSizes[key] = value!;
            });
          },
        );
      }).toList(),)
    );
  }

  getColorsCheckbox() {
    List<String> keys = possibleColors.keys.toList(growable: false);

    return Expanded(child: new ListView(
      children: keys.map((String key) {
        return CheckboxListTile(
          activeColor: yellowStrong,
          title: Text(key),
          value: possibleColors[key],
          onChanged: (bool? value) {
            setState(() {
              possibleColors[key] = value!;
            });
          },
        );
      }).toList(),)
    );

  }

  validateButton() {
    return Positioned(
        right: 10,
        bottom: 10,
        child : FloatingActionButton(
          backgroundColor: yellowStrong,
          child: Icon(Icons.check_outlined),
          onPressed: () {

            if(_form.currentState!.validate()) {
              _form.currentState!.save();

              // bring shoes choices
              possibleShoesSizes.forEach((key, value) {
                if(value && !widget.item!.shoesSizeAvailable.contains(key)) {
                  widget.item!.shoesSizeAvailable.add(key);
                } else if(!value && widget.item!.shoesSizeAvailable.contains(key)) {
                  widget.item!.shoesSizeAvailable.remove(key);
                }
              });

              // bring clothes choices
              possibleClothesSizes.forEach((key, value) {
                if(value && !widget.item!.clothesSizedAvailable.contains(key)) {
                  widget.item!.clothesSizedAvailable.add(key);
                } else if(!value && widget.item!.clothesSizedAvailable.contains(key)) {
                  widget.item!.clothesSizedAvailable.remove(key);
                }
              });

              // bring color choices
              possibleColors.forEach((key, value) {
                if(value && !widget.item!.colorsAvailable.contains(key)) {
                  widget.item!.colorsAvailable.add(key);
                } else if(!value && widget.item!.colorsAvailable.contains(key)) {
                  widget.item!.colorsAvailable.remove(key);
                }
              });

              widget.callback(widget.item!);
              Navigator.of(context).pop();
            }

          },
        )
    );
  }

  getLabel(String txt) {
    return Text("${txt}", style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 20
    ),);
  }

}