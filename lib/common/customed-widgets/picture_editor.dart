import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_frontend/application_state.dart';
import 'package:mobile_frontend/common/classes/item_photo_info.dart';
import 'package:mobile_frontend/common/classes/picker.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/constraints.dart';

/**
 * Class that handle
 */
class ItemPhotoEditor extends StatefulWidget {

  final int maxImages;
  final List<ItemPhotoInfo> basePictures;
  final Function(List<ItemPhotoInfo>) callback;

  const ItemPhotoEditor({Key? key, required this.basePictures, required this.callback, required this.maxImages}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemPhotoEditor();
}

class _ItemPhotoEditor extends State<ItemPhotoEditor> {

  List<ItemPhotoInfo> pictures = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.loadPictures();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  /**
   * load item photo if exists
   */
  void loadPictures() {
    if(widget.basePictures != null) {
      this.pictures = widget.basePictures.where((element) => true).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Material(
        color: yellowLight,
        child: Stack(
          children: [

            Center(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: pictures.map<Widget>((photoInfo) {
                  return itemWidget(photoInfo, size);
                }).toList()
              ),
            ),


            Positioned(
              right: 10,
              bottom: 10,

              child: Column(

                children: [

                  getPhotoListSize()  < widget.maxImages ? addPhotoFromPicker(): Container(),
                  SizedBox(height: 5,),

                  getPhotoListSize()  < widget.maxImages ? addPhotoFromGallery(): Container(),
                  SizedBox(height: 5,),

                  // hasAnyModification() ? revokeActions(): Container(),
                  // SizedBox(height: 5,),

                  hasAnyModification() ? validateButton(): Container()

                ],
              ),
            )

          ],
        )
    );

  }

  itemWidget(ItemPhotoInfo photoInfo, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        GestureDetector(
          child: Container(
            height: 150,
            width: size.width / 1.5,
            margin: EdgeInsets.only(top: 10, bottom: 10),

            decoration: BoxDecoration(
              color: getColor(photoInfo),
              borderRadius: new BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: this.getImage(photoInfo) ,
            ),
          ),

          onTap: () {
            showDialog(context: context, builder: (context) => Popup.showImageGeneric(photoInfo));
          },

          onLongPress: () {
            showDialog(context: context, builder: (context) => Popup.confirmRemovePhoto(context, () {
              removePhoto(photoInfo);
            }));
          },

        )

      ],
    );
  }

  getColor(ItemPhotoInfo photoInfo) {
    if (photoInfo.isDeleted!) {
      return lightRed;
    } else if(photoInfo.isNew!) {
      return lightGreen;
    } else {
      return yellowSemi;
    }
  }

  getImage(ItemPhotoInfo photoInfo) {
    // print("uri: ${picture.uri}");
    String prefix = photoInfo.url.toString().substring(0, 5);
    bool isRemoteImage = prefix.contains("http") || prefix.contains("https");

    return isRemoteImage ? 
      Image.network(photoInfo.url!, fit: BoxFit.contain,)
      : Image.file(photoInfo.file!);
  }

  //////////////////////////////////
  //////////   BUTTONS   ///////////
  //////////////////////////////////

  addPhotoFromPicker() {
    return FloatingActionButton(
      backgroundColor: yellowSemi,
      child: Icon(Icons.add_a_photo, color: yellowStrong, size: 30),
      onPressed: () {
        addPhoto(ImageSource.camera);
      },
    );
  }

  addPhotoFromGallery() {
    return FloatingActionButton(
          backgroundColor: yellowSemi,
          child: Icon(Icons.add_photo_alternate, color: yellowStrong, size: 35),
          onPressed: () {
            addPhoto(ImageSource.gallery);
          },
    );
  }
  //
  //
  // revokeActions() {
  //   return FloatingActionButton(
  //     backgroundColor: lightRed,
  //     child: Icon(Icons.highlight_remove, color: white, size: 30),
  //     onPressed: () {
  //       widget.callback(widget.basePictures.map((e) {
  //
  //         ItemPhotoInfo itemPhotoInfo = new ItemPhotoInfo();
  //         itemPhotoInfo.url = e.url;
  //         itemPhotoInfo.isNew = f
  //
  //       }));
  //       Navigator.pop(context);
  //     },
  //   );
  // }

  validateButton() {
    return FloatingActionButton(
      backgroundColor: yellowStrong,
      child: Icon(Icons.check_outlined, size: 30),
      onPressed: () {
        widget.callback(pictures);
        Navigator.pop(context);
      },
    );
  }

  //////////////////////////////////
  //////////   HANDLE    ///////////
  //////////////////////////////////

  // a revoir car mal fait
  // ca ne tient pas en comtep tout les cas
  hasAnyModification() {
    return true;
    // return pictures.where((currentPhotoInfo) => currentPhotoInfo.isNew!).toList().length > 0;
  }

  getPhotoListSize() {
    return pictures.where((currentPhotoInfo) => !currentPhotoInfo.isDeleted!).toList().length;
  }

  addPhoto(ImageSource imageSource) async {
    File? file = await ImagePickerWrapper.getImageFromGallery(imageSource);

    if(file == null) {
      // show error message
    } else {

      ItemPhotoInfo photoInfo = new ItemPhotoInfo();
      photoInfo.url = file.path;
      photoInfo.isNew = true;
      photoInfo.isDeleted = false;
      photoInfo.file = file;
      photoInfo.name = this.createImageName();

      setState(() {
        pictures.add(photoInfo);
      });
    }
  }

  removePhoto(ItemPhotoInfo photoInfo) {
    setState(() {
      pictures.forEach((currentPhotoInfo) {

        if(currentPhotoInfo.url == photoInfo.url) {
          currentPhotoInfo.isDeleted = true;
        }

      });
    });
  }

  createImageName() {
    String name = applicationState.authUser!.marketplace!.name!;

    var now = new DateTime.now();
    var formatter = new DateFormat('_ddMMyyyy_HHmmss');
    name += formatter.format(now);
    name += "_";
    name += (pictures.length + 1).toString();

    print("image name: ${name}");
    return name;
  }

}