import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/customed-widgets/ConfirmLekketWidget.dart';
import 'package:mobile_frontend/common/material/round-button.dart';
import 'package:mobile_frontend/common/bloc/auth_bloc.dart';
import '../../constraints.dart';
import 'item_photo_info.dart';

class Popup {

  static modal(context, Widget widget) {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        elevation: 80.0,

        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.only(topLeft: const Radius.circular(20.0), topRight: const Radius.circular(30.0)),
        ),

        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: widget,
          );
        }
    );
  }

  static inform(context, title, message) {
    return new AlertDialog(
      backgroundColor: yellowLight,
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          SizedBox(height: sizedBoxHeight),
          Center(
            child: Icon(Icons.error_outline, size: 50, color: yellowStrong),
          )
        ]
      )
    );
  }

  static error(context, mess) {
    return new AlertDialog(
      backgroundColor: yellowSemi,
      title: Text(mess),
      content: Column(
      
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Un problème s'est produit. Veuillez nous excuser."),
          SizedBox(height: sizedBoxHeight),
          Center(
            child: Icon(Icons.error_outline, size: 50),
          )
        ]
      )
    );
  }

  static confirmDeconnection(context, mess) {
    return new AlertDialog(
      backgroundColor: yellowLight,
      title: Text("Quitter Wanémarket ?"),
      content: Column(
      
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Toute modifications non enregistrée sera perdue", style: TextStyle(fontSize: 13),),
          SizedBox(height: sizedBoxHeight),
          Center(
            child: RoundButton(
              icon: Icon(Icons.double_arrow, color: Colors.white),
              width: 50,
              height: 50,
              buttonColor: lightRed,
              callback: () async {        
                await authBloc.releaseAuth();
                Navigator.pop(context);
              },
            )
          )
        ]
      )
    );
  }

  static confirmMarketplaceDecision(context, decision, callback) {
    return new AlertDialog(
        backgroundColor: yellowLight,
        title: Text(decision ? "Valider cet annonceur" : "Refuser cet annonceur"),
        content: Column(

            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Etes vous sur ?", style: TextStyle(fontSize: 13),),
              SizedBox(height: sizedBoxHeight),
              Center(
                  child: RoundButton(
                    icon: Icon(Icons.double_arrow, color: Colors.black),
                    width: 50,
                    height: 50,
                    buttonColor: decision ? lightGreen : lightRed,
                    callback: () async {
                      callback();
                      Navigator.pop(context);
                    },
                  )
              )
            ]
        )
    );
  }

  static confirmAnnonceDecision(context, decision, callback) {
    return new AlertDialog(
        backgroundColor: yellowLight,
        title: Text(decision ? "Valider cet annonce" : "Refuser cet annonce"),
        content: Column(

            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Etes vous sur ?", style: TextStyle(fontSize: 13),),
              SizedBox(height: sizedBoxHeight),
              Center(
                  child: RoundButton(
                    icon: Icon(Icons.double_arrow, color: Colors.black),
                    width: 50,
                    height: 50,
                    buttonColor: decision ? lightGreen : lightRed,
                    callback: () async {
                      callback();
                      Navigator.pop(context);
                    },
                  )
              )
            ]
        )
    );
  }

  static showImageGeneric(ItemPhotoInfo photoInfo) {
    Image image;

    if(photoInfo.isNew!) {
      image = Image.file(photoInfo.file!);
    } else {
      image = Image.network(photoInfo.url!);
    }

    return AlertDialog(
      backgroundColor: yellowLight,
      content: Column(

        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image
        ]
      )
    );
  }

  static showImage(File file) {
    return AlertDialog(
      backgroundColor: yellowLight,
      content: Column(
      
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(file)
        ]
      )
    );
  }

  static showImageNetwork(String url) {
    return AlertDialog(
      backgroundColor: yellowLight,
      content: Column(
      
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(url)
        ]
      )
    );
  }

  static confirmImageRemoving(context, String filename, callback) {
    return AlertDialog(
      backgroundColor: yellowLight,
      title: Text("Supprimer ?"),
      content: Column(
      
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Image: ${filename}", style: TextStyle(fontSize: 13),),
          SizedBox(height: sizedBoxHeight),
          Center(
            child: RoundButton(
              icon: Icon(Icons.remove, color: Colors.black),
              width: 50,
              height: 50,
              buttonColor: yellowStrong,
              callback: () async {        
                callback();
                Navigator.pop(context);
              },
            )
          )
        ]
      )
    );
  }

  static confirmDelete(context, title, mess, callback) {
    return AlertDialog(
      backgroundColor: yellowLight,
      title: Text(title),
      content: Column(
      
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mess, style: TextStyle(fontSize: 13),),
          SizedBox(height: sizedBoxHeight),
          Center(
            child: RoundButton(
              icon: Icon(Icons.delete, color: Colors.black),
              width: 50,
              height: 50,
              buttonColor: lightRed,
              callback: () async {        
                callback();
                // Navigator.of(context).pop();
                Navigator.pop(context);
              },
            )
          )
        ]
      )
    );
  }

  static showItem(int itemId) {
    return AlertDialog(
      backgroundColor: yellowLight,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.only(top: 20),
      content: Container()//ItemDescriptionMin(itemId)
    );
  }

  static confirmLekket(context, clientCallback) {
    return new AlertDialog(
      backgroundColor: yellowLight,
      title: Text("Ajouter à la lekket ?"),
      content: ConfirmLekketWidget(callback: (int quantity, String shoeSize, String clotheSize, String color, String? descr) {
        print("quantityyy; ${quantity}");
        clientCallback(quantity);
      },)
    );
  }

  static updateLekketQuantity(context, int? currentQuantity, callback) {
    return new AlertDialog(
      backgroundColor: yellowLight,
      title: Text("Modifier la lekket ?"),
      content: Column(
      
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: sizedBoxHeight),

          Center(
            child: RoundButton(
              icon: Icon(Icons.shopping_basket, color: Colors.black),
              width: 50,
              height: 50,
              buttonColor: yellowSemi,
              callback: () async {        
                
                callback();
                Navigator.pop(context);

              },
            )
          )
        ]
      )
    );
  }

  static confirmRemoveLekket(context, callback) {
    return new AlertDialog(
      backgroundColor: yellowLight,
      title: Text("Supprimer l'article du panier ?"),
      content: Column(
      
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Confirmer la suppression.", style: TextStyle(fontSize: 13),),
          SizedBox(height: sizedBoxHeight),
          Center(
            child: RoundButton(
              icon: Icon(Icons.delete, color: Colors.black),
              width: 50,
              height: 50,
              buttonColor: lightPink,
              callback: () async {        
                
                callback();
                Navigator.pop(context);

              },
            )
          )
        ]
      )
    );
  }

  static confirmAddWishList(context, callback) {
    return new AlertDialog(
      backgroundColor: yellowLight,
      title: Text("Ajouter aux favoris ?"),
      content: Column(
      
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ajouter aux favoris", style: TextStyle(fontSize: 13),),
          SizedBox(height: sizedBoxHeight),
          Center(
            child: RoundButton(
              icon: Icon(Icons.favorite_border, color: Colors.black),
              width: 50,
              height: 50,
              buttonColor: lightPink,
              callback: () async {        
                
                callback();
                Navigator.pop(context);

              },
            )
          )
        ]
      )
    );
  }

  static confirmRemoveWishList(context, callback) {
    return new AlertDialog(
      backgroundColor: yellowLight,
      title: Text("Bëgëtuma ?"),
      content: Column(
      
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Retiere des favoris", style: TextStyle(fontSize: 13),),
          SizedBox(height: sizedBoxHeight),
          Center(
            child: RoundButton(
              icon: Icon(Icons.remove, color: Colors.black),
              width: 50,
              height: 50,
              buttonColor: lightPink,
              callback: () async {        
                
                callback();
                Navigator.pop(context);

              },
            )
          )
        ]
      )
    );
  }

  static confirmRemovePhoto(context, callback) {
    return new AlertDialog(
        backgroundColor: yellowLight,
        title: Text("Suppression ?"),
        content: Column(

            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Supprimer la photo ?", style: TextStyle(fontSize: 13),),
              SizedBox(height: sizedBoxHeight),
              Center(
                  child: RoundButton(
                    icon: Icon(Icons.remove, color: Colors.black),
                    width: 50,
                    height: 50,
                    buttonColor: lightPink,
                    callback: () async {
                      callback();
                      Navigator.pop(context);
                    },
                  )
              )
            ]
        )
    );
  }

}