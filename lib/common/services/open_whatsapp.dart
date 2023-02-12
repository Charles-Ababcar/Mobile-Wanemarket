
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WhatsAppCall {

  static Future<void> open(String tel, context) async {
    String telephoneUrl = "tel:$tel";

    final String whatsappURLAndroid =
    "whatsapp://send?phone=$telephoneUrl&text=Bonjour Wanémarket, Je vous contacte depuis l'application mobile afin de ...";

    final String whatsappURLIos =
    "https://wa.me/$telephoneUrl?text=Bonjour Wanémarket, Je vous contacte depuis l'application mobile afin de ...";

    if (Platform.isIOS) {
      //pour téléphone IOS uniquement

      if (await canLaunchUrlString(whatsappURLIos)) {
        !await launchUrlString(whatsappURLIos);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("WhatsApp non installé")));
      }
    } else {
      print("**************");
      if (Platform.isAndroid) {
        // pour téléphone android, web
        if (await canLaunchUrlString(whatsappURLAndroid)) {
          !await launchUrlString(whatsappURLAndroid);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("WhatsApp non installé")));
        }
      }
    }
  }

}