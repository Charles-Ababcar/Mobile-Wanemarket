import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/bloc/article/article_bloc.dart';
import 'package:mobile_frontend/common/bloc/categories_bloc.dart';
import 'package:mobile_frontend/common/classes/article.dart';
import 'package:mobile_frontend/common/classes/category.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/material/dropdown.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/material/round-button.dart';
import 'package:mobile_frontend/common/material/tag_item.dart';
import 'package:mobile_frontend/common/material/texfield_digits.dart';
import 'package:mobile_frontend/common/material/textarea.dart';

// wane-material
import 'package:mobile_frontend/common/material/textfield.dart';
import 'package:mobile_frontend/common/material/main-button.dart';

// compoenents 
import 'package:mobile_frontend/common/customed-widgets/custom-scrollable.dart';
import 'package:mobile_frontend/common/customed-widgets/custom-scaffold.dart';

import '../../../../constraints.dart';
import 'package:image_picker/image_picker.dart';

class NewItemForm extends StatefulWidget {
  const NewItemForm({Key? key}) : super(key: key);

  @override
  _NewItemForm createState() => _NewItemForm();
}

class _NewItemForm extends State<NewItemForm> {

  ///                  IMAGE PUCKING                  ///
  /// /////////////////////////////////////////////// ///
  ///                                                 ///

  /**
   * Take an image
   */
  ImagePicker picker = ImagePicker();

  /**
   * all selected images
   */
  Map<String, File>? images  = new Map();

  /**
   * max images to be imported
   * depend on subscription
   */
  final int maxImages = 3;

  ///                  BLOC / FORM                    ///
  /// /////////////////////////////////////////////// ///
  ///                                                 ///

  /**
   * logic bloc
   */
  final categoriesBloc = new CategoriesBloc();

  final articleBloc = new ArticleBloc();

  /**
   * key form
   */
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  /**
   *
   */
  Item? item = new Item();
  int? categoryId;

  ///                                                 ///
  /// /////////////////////////////////////////////// ///
  ///                                                 ///

  @override
  void initState() {
    super.initState();

    categoriesBloc.loadAllCategories();
  }

  @override
  void dispose() {
    super.dispose();
    ownerItemsBloc.loadOwnerArticles();
    categoriesBloc.dispose();
    articleBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ScaffoldCustom(

      body: StreamBuilder<bool?> (
        stream: articleBloc.successRequestStream,
        initialData: false,
        builder: (context, snapshot) {

          if(snapshot.data == false) {
            return globalForm(size);
          } else {
            return successForm(size);
          }

        },
      ),
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
              "Wanémarket va étudier votre annonce " +
              "afin de respecter les règles d'usage. Une " +
              "fois votre demande validée, elle sera automatiquement disponible.",
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

  Widget globalForm(Size size) {
    return Container(

      child: Form(
        key: _formKey,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            /**
             * container input
             */
            new Container(
              padding: EdgeInsets.only(top: 50),
              height: size.height * 1,
              width: size.width * 0.9,

              /**
               * column including inputs
               */
              child: CustomScrollable (
                child:
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
                  children: <Widget>[
                      // InfoContainer(
                      //   icon: Icon(Icons.info_rounded, size: 40, color: yellowStrong,),
                      //   contentColor: yellowSemi,
                      //   borderColor: yellowSemi,
                      //   text: Text("Vous pouvez ajouter une photo de depuis votre gallerie. Les administrateurs vérifieront votre article avant de le publier.", style: TextStyle()),
                      // ),
                      errorStream(),

                      SizedBox(height: sizedBoxHeight),

                      /**
                       * TextField email/phone
                       */
                      itemNameFormField(),
                      SizedBox(height: sizedBoxHeight),

                      /**
                       * textfield price
                       */
                      itemPriceFormField(),
                      SizedBox(height: sizedBoxHeight),

                    /**
                       * Textfield description
                       */
                      itemDescriptionFormField(),

                      SizedBox(height: sizedBoxHeight),

                      /**
                       * Textfield category
                       */
                      itemCategoryFormField(),

                      SizedBox(height: sizedBoxHeight),

                      getShoesSizeCheckbox(),
                      SizedBox(height: sizedBoxHeight),

                      getClothesSizeCheckbox(),
                      SizedBox(height: sizedBoxHeight),

                      getColorsCheckbox(),
                      SizedBox(height: sizedBoxHeight),

                      /**
                       * image picker button
                       */
                      imagePickerButton(),

                      SizedBox(height: sizedBoxHeight),

                      /**
                       * Photo handler
                       */
                      itemPhotosArea(size),

                      SizedBox(height: sizedBoxHeight),

                      /**
                       * connection button
                       */
                      sendingButton(),

                      loadingStreamIcon()

                    ],

                  ),

                )

              ),
          ],

        ),

       )

    );
  }

  //////////////////////////////////
  //////////   WIDGETS   ///////////
  //////////////////////////////////

  Widget itemNameFormField() {
    return new TextFieldContainer(
      textFieldHintText: "Nom de l'article",
      customedIcon: Icon(Icons.article, size: 20),
      maxLength: 50,

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
    return new TextFieldDigitsContainer(
      textFieldHintText: "Prix",
      customedIcon: Icon(Icons.monetization_on, size: 20),

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

          return new Dropdown(


            pickedValue: categories[0].id.toString(),

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

  imagePickerButton() {
    // image picker trigger
    return (images!.length >= maxImages)
    ?
    Container()
    :
    RoundButton(
      height: 50,
      width: 50,
      icon: Icon(Icons.image),
      buttonColor: yellowSemi,

      callback: () {
        getImage();
      },
    );
  }

  loadingStreamIcon() {
    return StreamBuilder<bool?> (
      stream: articleBloc.loadingStream,
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


  Widget itemPhotosArea(Size size) {

    return Container(
        height: 120,
        width: size.width,

        child: new ListView.builder(

          itemCount: images?.length,

          itemBuilder: (BuildContext context, int index) {
            String fileAppelation = images!.keys.elementAt(index);

            /**
             * create tag
             * for each tag, we can show it
             * or cancel it
             */
            return new TagItem(
              color: yellowSemi,
              text: fileAppelation.toString(),

              onTap: (String filename) {
                showImage(filename);
              },

              onLongPress: (String filename) {
                removeImage(filename);
              },

            );
          },

        ),
    );
  }

  void showImage(String filename) {
    File? file = images![filename];

    if(file != null) {

      showDialog(context: context, builder: (context) {
        return Popup.showImage(file);
      });
    }
  }

  void removeImage(String filename) {
    File? file = images![filename];

    if(file != null) {

      showDialog(context: context, builder: (context) {
        return Popup.confirmImageRemoving(
          context,
          filename,
          () {
            setState(() {
              images!.remove(filename);
            });
          }
        );
      });

    }
  }

  //////////////////////////////////
  //////   IMAGE HANDLING    ///////
  //////////////////////////////////

  Future getImage() async {

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File image = File(pickedFile.path);

        print(image.path);
        List<String> splitted = image.path.split("/");
        String fileName = splitted[splitted.length -1].replaceFirst("image_picker", "wane_image");

        // add to map
        setState(() {
          images![fileName] = image;
        });
      }

    setState(() {

    });
  }


  //////////////////////////////////
  //////   SENDING BUTTON    ///////
  //////////////////////////////////

  Widget sendingButton() {
    return MainButton(

      buttonText: "Créer une annonce",

      onPressed: () async {
        if(_formKey.currentState!.validate()) {

          // validate form
          _formKey.currentState!.save();

          // create category
          Category pickedCategory = new Category(categoryId!, "");
          item!.category = pickedCategory;

          inspect(pickedCategory);

          int? marketplaceId = applicationState.authUser!.marketplace?.id;
          // await articleBloc.submit(marketplaceId, item!, images);

          // send form

        }
      },
    );
  }

  Widget errorStream() {
    return StreamBuilder<String?> (
      stream: articleBloc.loginErrorStream,
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
          return new SizedBox(height: 0,);
        }
      }
    );
  }

  getShoesSizeCheckbox() {
    return Text("Tailles de chaussures (optionnel)");
  }

  getClothesSizeCheckbox() {
    return Container();
  }

  getColorsCheckbox() {
    return Container();
  }

}