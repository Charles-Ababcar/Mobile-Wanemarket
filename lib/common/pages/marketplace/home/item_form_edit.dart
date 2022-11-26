import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/article/article_bloc.dart';
import 'package:mobile_frontend/common/bloc/article/article_description_bloc.dart';
import 'package:mobile_frontend/common/bloc/article/article_edit_bloc.dart';
import 'package:mobile_frontend/common/bloc/categories_bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/category.dart';
import 'package:mobile_frontend/common/classes/item_photo_info.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-scrollable.dart';
import 'package:mobile_frontend/common/customed-widgets/picture_editor.dart';
import 'package:mobile_frontend/common/material/dropdown.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/material/round-button.dart';
import 'package:mobile_frontend/common/material/texfield_digits.dart';
import 'package:mobile_frontend/common/material/textarea.dart';
import 'package:mobile_frontend/common/material/textfield.dart';
import 'package:mobile_frontend/common/pages/marketplace/sizes_editor.dart';
import 'package:mobile_frontend/constraints.dart';

class ItemFormEdit extends StatefulWidget {

  // if != null then its an update
  final int? itemId;

  // callback giving the
  final void Function(Item, List<ItemPhotoInfo>)? callback;

  const ItemFormEdit({Key? key, this.itemId, this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemFormEdit();

}

class _ItemFormEdit extends State<ItemFormEdit> {

  // bloc
  ArticleDescriptionBloc articleDescriptionBloc = new ArticleDescriptionBloc();

  // form key
  GlobalKey<FormState> _formKeyUpdate = new GlobalKey<FormState>();

  // item
  Item? item;
  int? categoryId;

  bool didLoadImage = false;

  // images
  List<ItemPhotoInfo> itemPictures  = [];

  // blocs
  final categoriesBloc = new CategoriesBloc();

  @override
  void initState() {
    super.initState();

    // init default value
    item = new Item();
    item!.title       = "";
    item!.price       = 0;
    item!.description = "";

    // bring data
    this.articleDescriptionBloc.loadItem(widget.itemId, false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this.articleDescriptionBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Material(
      color: yellowLight,
      child: StreamBuilder<bool?> (
        stream: articleEditBloc.successRequestStream,
        initialData: false,
        builder: (context, snapshot) {
          if(snapshot.data == true) {
            return successForm(size);
          } else {
            return WillPopScope(
              onWillPop: articleEditBloc.canPopPage,
              child: getMain(size),
            );
          }
        },

      )
    );
  }

  //////////////////////////////////
  //////////  ITEM FORM  ///////////
  //////////////////////////////////

  getMain(Size size) {
    return Stack(
      children: [

        // load appropriate form
        Center(
            child: getUpdateForm(size)
        ),

        // add photo buttons
        addSizesForm(),
        // add photo buttons
        addPhotoButton(),

        // validation button
        validateButton(),

      ],
    );
  }

  getUpdateForm(Size size) {
    return StreamBuilder<Item?> (
      stream: articleDescriptionBloc.itemStream,
      initialData: null,
      builder: (context, snapshot) {

        // load categories
        if (snapshot.hasData) {
          categoriesBloc.loadAllCategories();

          this.item = snapshot.data;

          if(categoryId == null) {
            categoryId = item!.category!.id;
          }

          if(!didLoadImage) {
            item!.photos.forEach((photo) {
              ItemPhotoInfo photoInfo = new ItemPhotoInfo();
              photoInfo.id = photo.id;
              photoInfo.url = photo.url!;
              photoInfo.isNew = false;
              photoInfo.isDeleted = false;
              itemPictures.add( photoInfo );
            });
            didLoadImage = true;
          }

          return Form(
            key: _formKeyUpdate,
            child: getFormFields(size),
          );
        } else {
          return LoadingIcon();
        }
      }
    );
  }

  getFormFields(Size size) {
    return Container(
        padding: EdgeInsets.only(top: 70),
        height: size.height * 1,
        width: size.width * 0.9,

        child: CustomScrollable (
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
                children: <Widget>[

                  // error stream
                  infoStream(),
                  SizedBox(height: sizedBoxHeight),

                  // error stream
                  errorStream(),
                  SizedBox(height: sizedBoxHeight),

                  //TextField email/phone
                  itemNameFormField(),
                  SizedBox(height: sizedBoxHeight),

                  //TextField price
                  itemPriceFormField(),
                  SizedBox(height: sizedBoxHeight),

                  // category
                  itemCategoryFormField(),
                  SizedBox(height: sizedBoxHeight),

                  //TextField description
                  itemDescriptionFormField(),
                  SizedBox(height: sizedBoxHeight),

                  loadingStreamIcon(),
                  SizedBox(height: sizedBoxHeight)

                ]
            )
        )
    );
  }

  Widget itemNameFormField() {
    return TextFieldContainer(
      textFieldHintText: "Nom de l'article",
      customedIcon: Icon(Icons.article, size: 20),
      maxLength: 50,
      initialValue: item!.title,

      onValidate: (Object? value) {
        if(value.toString().isEmpty) {
          return "Saisir un titre";
        }
        return "";
      },

      onSave: (Object? value) {
        item!.title = value.toString();
      },

    );
  }

  Widget itemPriceFormField() {
    return TextFieldDigitsContainer(
      textFieldHintText : "Prix",
      customedIcon      : Icon(Icons.monetization_on, size: 20),
      initialValue      : item!.price == 0 ? "": item!.price.toString(),

      onValidate: (Object? value) {

        if(value.toString().isEmpty) {
          return "Saisir un prix";
        }
        return "";
      },

      onSave: (Object? value) {
        item!.price = double.parse(value.toString());
      },

    );
  }

  Widget itemDescriptionFormField() {
    return TextAreaContainer(
      textFieldHintText: "Description de l'article (150 mots)",
      initialValue:  item!.description,

      onValidate: (Object? value) {
        if(!value.toString().isEmpty && value.toString().length > 200) {
          return "La description ne doit pas dépasser 200 lettres";
        }
        return "";
      },

      onSave: (Object? value) {
        item!.description = value.toString();
      },
    );
  }

  Widget itemCategoryFormField() {
    return StreamBuilder< List<Category>? > (

      stream: categoriesBloc.stream,
      initialData: null,
      builder: (context, snapshot) {

        if(!snapshot.hasData || snapshot.data == null) {
          return LoadingIcon();
        } else {
          List<Category> categories = snapshot.data!;
          // categoryId = categories[1].id;

          if(categoryId == null) {
            categoryId = categories[0].id;
          }

          return Dropdown(
            pickedValue: categoryId.toString(),

            whenOnChange: (String newValue) {
              setState(() {
                categoryId = int.parse(newValue);
                print("-- categoy ${categoryId}");
              });
            },

            items: categories.map<DropdownMenuItem<String>>((Category category) {
              return DropdownMenuItem<String>(
                value: category.id.toString(),
                child: Text(category.title!),
                // child: Text("ok!"),
              );
            }).toList()
          );
        }
      },
    );
  }

  //////////////////////////////////
  //////////   PAGES     ///////////
  //////////////////////////////////

  Widget successForm(Size size) {
    return Container(
      height: size.height,
      width: size.width,

      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          InfoContainer(
            icon: Icon(
              Icons.beenhere_outlined,
              size: 40,
              color: yellowStrong,
            ),
            contentColor: yellowSemi,
            borderColor: yellowSemi,
            text: Text(
                "Annonce modifiée\n" +
                    "Veuillez attendre quelques minutes afin que la modification soit visible",
                style: TextStyle()
            ),
          ),

          SizedBox(height: sizedBoxHeight),

          RoundButton(
            buttonColor: yellowSemi,
            icon: Icon(Icons.arrow_back, color: yellowStrong,),
            height: 50,
            width: 50,
            callback: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget infoStream() {
    return StreamBuilder<bool?> (
      stream: articleEditBloc.loadingStream,
      initialData: false,
      builder: (context, snapshot) {

        // si rien, affiche rien
        if(!snapshot.data!) {
          return Container();
        } else if(snapshot.hasData) {
          return Column (
            children: [
              /**
               * request errorù
               */
              SizedBox(height: sizedBoxHeight),

              InfoContainer(
                icon: Icon(Icons.cloud_download, size: 40, color: yellowStrong),
                contentColor: yellowSemi,
                borderColor: yellowStrong,
                height: 100,
                text: Text("L'opération peut prendre quelque temps", style: TextStyle()),
              ),

              SizedBox(height: sizedBoxHeight),
            ],
          );
        } else {
          return new Container();
        }
      }
    );
  }

  loadingStreamIcon() {
    return StreamBuilder<bool?> (
      stream: articleEditBloc.loadingStream,
      initialData: false,
      builder: (context, snapshot) {

        if(snapshot.hasData) {
          if(snapshot.data == true) {
            return LoadingIcon();
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      }
    );
  }

  Widget errorStream() {
    return StreamBuilder<String?> (
      stream: articleEditBloc.errorStream,
      initialData: null,
      builder: (context, snapshot) {

        // si rien, affiche rien
        if(snapshot.data == null) {
          return Container();
        } else if(snapshot.hasData) {
          return Column (
            children: [
              /**
               * request errorù
               */
              SizedBox(height: sizedBoxHeight),

              InfoContainer(
                icon: Icon(Icons.warning_amber_rounded, size: 40, color: Colors.red),
                contentColor: lightRed,
                borderColor: lightRed,
                height: 100,
                text: Text(snapshot.data.toString().toLowerCase(), style: TextStyle()),
              ),

              SizedBox(height: sizedBoxHeight),
            ],
          );
        } else {
          return new Container();
        }
      }
    );
  }

  //////////////////////////////////
  //////////   BUTTONS   ///////////
  //////////////////////////////////


  addSizesForm() {
    return Positioned(
        right: 15,
        bottom: 145,
        child : FloatingActionButton(
          backgroundColor: yellowSemi,
          child: Icon(Icons.checkroom, color: yellowStrong, size: 30),
          onPressed: () {
            Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context) {
                  return ItemSizesEditor(
                    item: item,
                    callback: (Item updatedItem) {
                      item!.shoesSizeAvailable    = updatedItem.shoesSizeAvailable;
                      item!.clothesSizedAvailable = updatedItem.clothesSizedAvailable;
                      item!.colorsAvailable       = updatedItem.colorsAvailable;

                      print("taille shoes:   ${item!.shoesSizeAvailable}");
                      print("taille clothes: ${item!.clothesSizedAvailable}");
                      print("colors:         ${item!.colorsAvailable}");
                    },
                  );
                }
            ));
          },
        )
    );
  }

  addPhotoButton() {
    return Positioned(
        right: 15,
        bottom: 80,
        child : FloatingActionButton(
          heroTag: 'addPic',
          backgroundColor: yellowSemi,
          child: Icon(Icons.photo_library_outlined, color: yellowStrong, size: 30),
          onPressed: () {
            Navigator.push(context, new MaterialPageRoute(
              builder: (BuildContext context) {
                return ItemPhotoEditor(
                  maxImages: MAX_IMAGES_DEFAULT,
                  basePictures: this.itemPictures.where((element) => true).toList(),
                  callback: (itemPicturesInfo) {
                    this.itemPictures = itemPicturesInfo;
                  }
                );
              }
            ));
          },
        )
    );
  }

  validateButton() {
    return Positioned(
      right: 15,
      bottom: 10,
      child : FloatingActionButton(
        heroTag: 'validate',
        backgroundColor: yellowStrong,
        child: Icon(Icons.check_outlined),
        onPressed: () {

          if(_formKeyUpdate.currentState!.validate()) {
            _formKeyUpdate.currentState!.save();

            item!.category!.id = categoryId;
            widget.callback!(item!, this.itemPictures);

            // Navigator.pop(context);
          }

        },
      )
    );
  }

}