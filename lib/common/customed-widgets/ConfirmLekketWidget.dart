import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/purchase_order.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/material/dropdown.dart';
import 'package:mobile_frontend/common/material/textarea.dart';
import 'package:mobile_frontend/constraints.dart';

class ConfirmLekketWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ConfirmLekketWidget();

  final ItemLekket? itemLekket;
  final Item? item;
  final void Function(int quantity, String shoeSize, String clotheSize, String color, String? instructions)? callback;

  const ConfirmLekketWidget({Key? key, @required this.callback, this.itemLekket, this.item}) : super(key: key);
}

class _ConfirmLekketWidget extends State<ConfirmLekketWidget> {

  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List quantities = ["1", "2", "3", "4", "5", "6", "7" , "8", "9"];
  String pickedQuantity = "1";
  String? instructions;
  int? finalQuantityPicked = 1;

  String pickedShoesSize = "";
  String pickedShoesSizeFinal = "";

  String pickedClothesSize = "";
  String pickedClothesSizeFinal = "";

  String pickedColor = "";
  String pickedColorFinal = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.itemLekket != null) {
      instructions = widget.itemLekket!.instructions;
      pickedQuantity = widget.itemLekket!.quantity.toString();
      finalQuantityPicked = int.parse(pickedQuantity);
    }

    // picked value shoes
    if(widget.itemLekket != null && widget.itemLekket!.pickedShoeSize != null && widget.itemLekket!.pickedShoeSize != "") {
      pickedShoesSize = widget.itemLekket!.pickedShoeSize!;
      pickedShoesSizeFinal = widget.itemLekket!.pickedShoeSize!;
    } else if(widget.item!.shoesSizeAvailable.length > 0) {
      pickedShoesSize = widget.item!.shoesSizeAvailable[0];
      pickedShoesSizeFinal = widget.item!.shoesSizeAvailable[0];
    }

    // picked value shoes
    if(widget.itemLekket != null && widget.itemLekket!.pickedClotheSize != null && widget.itemLekket!.pickedClotheSize != null) {
      pickedClothesSize = widget.itemLekket!.pickedClotheSize!;
      pickedClothesSizeFinal = widget.itemLekket!.pickedClotheSize!;
    } else if(widget.item!.clothesSizedAvailable.length > 0) {
      pickedClothesSize = widget.item!.clothesSizedAvailable[0];
      pickedClothesSizeFinal = widget.item!.clothesSizedAvailable[0];
    }

    // picked value shoes
    if(widget.itemLekket != null && widget.itemLekket!.pickedColor != null && widget.itemLekket!.pickedColor != null) {
      pickedColor = widget.itemLekket!.pickedColor!;
      pickedColorFinal = widget.itemLekket!.pickedColor!;
    } else if(widget.item!.colorsAvailable.length > 0) {
      pickedColor = widget.item!.colorsAvailable[0];
      pickedColorFinal = widget.item!.colorsAvailable[0];
    }

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(

          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            widget.item!.shoesSizeAvailable.length == 0 ? Container(height: 0,): getLabel("Pointure désirée"),
            widget.item!.shoesSizeAvailable.length == 0 ? SizedBox(height: 0,) : SizedBox(height: sizedBoxHeight),
            widget.item!.shoesSizeAvailable.length == 0 ? SizedBox(height: 0,) : getShoesSizeCheckbox(),
            widget.item!.shoesSizeAvailable.length == 0 ? SizedBox(height: 0,) : SizedBox(height: sizedBoxHeight),

            widget.item!.clothesSizedAvailable.length == 0 ? SizedBox(height: 0,) : getLabel("Taille désirée:"),
            widget.item!.clothesSizedAvailable.length == 0 ? SizedBox(height: 0,) : SizedBox(height: sizedBoxHeight),
            widget.item!.clothesSizedAvailable.length == 0 ? SizedBox(height: 0,) : getClothesSizeCheckbox(),
            widget.item!.clothesSizedAvailable.length == 0 ? SizedBox(height: 0,) : SizedBox(height: sizedBoxHeight),

            widget.item!.colorsAvailable.length == 0 ? SizedBox(height: 0,) : getLabel("Couleurs désirée"),
            widget.item!.colorsAvailable.length == 0 ? SizedBox(height: 0,) : SizedBox(height: sizedBoxHeight),
            widget.item!.colorsAvailable.length == 0 ? SizedBox(height: 0,) : getColorsCheckbox(),

            // dropdown quantity
            SizedBox(height: sizedBoxHeight),
            getLabel("Quantité"),
            SizedBox(height: sizedBoxHeight),
            showDropDown(),
            SizedBox(height: sizedBoxHeight),

            getLabel("Instructions de commande"),
            SizedBox(height: sizedBoxHeight),
            instructionsInput(),
            SizedBox(height: sizedBoxHeight),

            // validate lekket
            SizedBox(height: 10,),
            confirmLekketButton()

          ]
      ),
    );
  }

  showDropDown() {
    return Dropdown(
      // pickedValue: widget.itemLekket ==  null ? pickedQuantity : widget.itemLekket!.id.toString(),
      pickedValue: pickedQuantity,

      whenOnChange: (String newValue) {
        setState(() {
          pickedQuantity = newValue;
          finalQuantityPicked = int.parse(pickedQuantity);
        });
      },

      items: ["1", "2", "3", "4", "5", "6", "7", "8", "9"].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value.toString(),
          child: Text(" ${value.toString()} "),
        );
      }).toList(),

    );
  }

  getLabel(String txt) {
    return Text("${txt}", style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 20
    ),);
  }

  Widget instructionsInput() {
    return TextAreaContainer(
      initialValue: instructions,
      textFieldHintText: "Indications supplémentaires",

      onValidate: (Object? value) {
        return "";
      },

      onSave: (Object? value) {
        instructions = value.toString();
      },
    );
  }

  confirmLekketButton() {
    return BigButton(
      background: yellowSemi,
      text: Text("Ajouter au panier"
        , style: TextStyle(color: Colors.black),),
      icon: Icon(Icons.shopping_basket, color: Colors.black,),
      callback: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          widget.callback!(finalQuantityPicked!, pickedShoesSizeFinal, pickedClothesSizeFinal, pickedColorFinal, instructions);
          Navigator.pop(context);
        }
      },
    );
  }

  getShoesSizeCheckbox() {

    return Dropdown(
      // pickedValue: widget.itemLekket ==  null ? pickedQuantity : widget.itemLekket!.id.toString(),
      pickedValue: pickedShoesSize,

      whenOnChange: (String newValue) {
        setState(() {
          pickedShoesSize = newValue;
          pickedShoesSizeFinal = pickedShoesSize;
          print("pointure choisie: ${pickedShoesSizeFinal}");
        });
      },

      items: widget.item!.shoesSizeAvailable.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value.toString(),
          child: Text(" ${value.toString()} "),
        );
      }).toList(),

    );
  }

  getClothesSizeCheckbox() {

    return Dropdown(
      // pickedValue: widget.itemLekket ==  null ? pickedQuantity : widget.itemLekket!.id.toString(),
      pickedValue: pickedClothesSize,

      whenOnChange: (String newValue) {
        setState(() {
          pickedClothesSize = newValue;
          pickedClothesSizeFinal = newValue;
          print("taille choisie: ${pickedClothesSizeFinal}");
        });
      },

      items: widget.item!.clothesSizedAvailable.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value.toString(),
          child: Text(" ${value.toString()} "),
        );
      }).toList(),
    );

  }

  getColorsCheckbox() {


    return Dropdown(
      pickedValue: pickedColor,

      whenOnChange: (String newValue) {
        setState(() {
          pickedColor = newValue;
          pickedColorFinal = newValue;
          print("color: ${pickedColorFinal}");
        });
      },

      items: widget.item!.colorsAvailable.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value.toString(),
          child: Text(" ${value.toString()} "),
        );
      }).toList(),
    );
  }

}