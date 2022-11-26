// Bouton récapitulatif + Bouton redirection
// Page ouverture page paydunya pour paiement
// Liste des commandes avec statut de commande
// Liste des articles d’une commande avec statut pour chaque article commandé
// Article en attente de récupération

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/bloc/article/purchase_list_bloc.dart';
import 'package:mobile_frontend/common/bloc/order/validate_lekket_bloc.dart';
import 'package:mobile_frontend/common/classes/order.dart';
import 'package:mobile_frontend/common/classes/popup.dart';
import 'package:mobile_frontend/common/classes/price-format.dart';
import 'package:mobile_frontend/common/classes/string-cut.dart';
import 'package:mobile_frontend/common/material/big-button.dart';
import 'package:mobile_frontend/common/material/info-container.dart';
import 'package:mobile_frontend/common/material/loading_icon.dart';
import 'package:mobile_frontend/common/material/round-button.dart';
import 'package:mobile_frontend/common/pages/payment/order_details_form.dart';
import 'package:mobile_frontend/common/pages/payment/payment_window.dart';
import 'package:mobile_frontend/constraints.dart';

class OrderValidation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrderValidation();
}

class _OrderValidation extends State<OrderValidation> {

  ValidateLekketBloc validateLekketBloc = new ValidateLekketBloc();

  bool isOrderDone = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // it will create an order and return it
    // validateLekketBloc.validateLekket();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    validateLekketBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Material(
      child: Container(
        padding: EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 10),
        child: isOrderDone ? getConfirmedOrder(size) : StreamBuilder<Order?> (
          stream: validateLekketBloc.ordertream,
          initialData: null,
          builder: (context, snapshot) {
            if(snapshot.data == null) {
              // create order request
              return getOrderForm();
            } else {
              // order is created, then pay by sms
              return getOrderInfos(context, snapshot.data!);
            }
          },
        )
      )
    );
  }

  // order confirmed,  orderDone = true
  getConfirmedOrder(size) {
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
                "Commande passée avec succès. Vous allez recevoir un SMS afin de finaliser le paiement ",
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
              // empty lekket
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  // orders form = validatedLekket = false && orderDone = false
  getOrderForm() {
    return OrderDetailsForm(
      callback: (Order order) {
        validateLekketBloc.validateLekket(order);
      }
    );
  }

  // orders info = validatedLekket = true && orderDone = false
  getOrderInfos(context, Order order) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        informationContainer(),

        SizedBox(
          height: 30,
        ),

        Text("Paiement de la commande",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

        Text("Commande du ${StringWrapper.formatDate(order.creationDate!, true)}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),


        SizedBox(
          height: 30,
        ),

        // articles
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Téléphone: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            Text("${order.phone!}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          ],
        ),

        // articles
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Adresse: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            Text("${order.address!}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          ],
        ),

        order.instructions != null ? SizedBox(height: 0,) : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Instructions: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            Text("${order.instructions!}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          ],
        ),

        // articles
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total articles: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
            Text("${PriceFormat.formatePrice(order.itemsAmount!)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
          ],
        ),

        // ship
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Frais de livraison: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
            Text("${PriceFormat.formatePrice(order.shipAmount!)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
          ],
        ),

        //total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total commande: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            Text("${PriceFormat.formatePrice(order.totalAmount!)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),

        Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                createPaymentSMS(context, order)
              ]
          ),
        )

      ],
    );
  }

  createPaymentSMS(context, Order order) {
    return BigButton(
      callback: () async {

        String? paymentUrl = await validateLekketBloc.createPayment(order.id!);

        await lekketListBloc.loadUserLekket();

        setState(() {
          isOrderDone = true;
        });

        openPaymentPage(paymentUrl!);
      },
      background: yellowSemi,
      icon: Icon(Icons.attach_money),
      text: Text("Payer par SMS"),
    );
  }

  openPaymentPage(String paymentUrl) {
    Navigator.push(context, new MaterialPageRoute(
        builder: (BuildContext context) {
          return new BrowserWindow(
            url: paymentUrl,
            callback: () {
              setState(() {
                isOrderDone = true;
              });
            },
          );
        }
    ));
  }

  Widget informationContainer() {
    return InfoContainer(
      height: 180,
      icon: Icon(
        Icons.info_rounded,
        size: 40,
        color: yellowStrong,
      ),
      contentColor: yellowSemi,
      borderColor: yellowSemi,
      text: Text(
          "Après le paiement de votre commande, les administrateurs devront la valider. Les annonceurs devront ensuite mettre à dispotion les articles payés ce qui déclenchera le service de livraison.",
          style: TextStyle(fontSize: 13)
      ),
    );
  }

  Widget errorController() {
    return StreamBuilder(
      stream: validateLekketBloc.errorStream,
      initialData: null,
      builder: (context, snapshot) {
        if(snapshot.data == null) {
          return SizedBox(height: 0,);
        } else {
          return InfoContainer(
            icon: Icon(Icons.warning_amber_rounded, size: 40, color: Colors.red),
            contentColor: lightRed,
            borderColor: lightRed,
            height: 100,
            text: Text(snapshot.data.toString().toLowerCase(), style: TextStyle()),
          );
        }
      },
    );
  }

}