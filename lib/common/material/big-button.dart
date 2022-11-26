import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {

  final Icon? icon;
  final Text? text;
  final Color? background;
  final void Function()? callback;

  const BigButton({Key? key, this.icon, this.text, this.background, this.callback}): super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    
    return InkWell(
      
      onTap: () => {
        callback!()
      },
      
      child: Container(
        height: 50,
        width: size.width, 
        margin: EdgeInsets.only(bottom: 5, top: 5),
        
        decoration: BoxDecoration(
          color: this.background,
          borderRadius: new BorderRadius.all(const Radius.circular(12.0))
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            this.icon == null ? Icon(Icons.abc): this.icon!,
            SizedBox(width: 10),
            this.text!
          ]
        ),
        
      )
    );
  }
  
}