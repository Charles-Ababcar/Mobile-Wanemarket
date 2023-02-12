import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/constraints.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class BrowserWindow extends StatelessWidget {
  final String? url;
  final Function() callback;

  const BrowserWindow({Key? key, this.url, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Material(
      child: Stack(
        children: [
          getQuitButton(context),

           WebviewScaffold(
             url: this.url!,
             withJavascript: true,
             supportMultipleWindows: true,
           ),

        // // web view
         getWebView(size),
        //
        // // return button triggering return
        ],
      ),
    );
  }

  getQuitButton(context) {
    return Positioned(
      right: 10,
      bottom: 10,
      child: FloatingActionButton(
        backgroundColor: lightRed,
        child: Icon(
          Icons.keyboard_return,
          color: yellowLight,
        ),
        onPressed: () {
          callback();
          Navigator.pop(context);
        },
      ),
    );
  }

  getWebView(Size size) {
    return Positioned(
      top: 0,
      left: 0,
      height: size.height,
      width: size.width,
      child: Container(),
      // child: WebviewScaffold(
      //   url: this.url!,
      //   withJavascript: true,
      //   supportMultipleWindows: true,
      // ),
    );
  }

}
