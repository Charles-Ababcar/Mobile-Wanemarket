import 'package:flutter/material.dart';
import 'package:mobile_frontend/constraints.dart';

enum ItemState {
  DEAL_WAITING,
  DEAL_WON,
  DEAL_LOST
}


  /**
   * Graphic content with wane signature which
   * show the price of elem, resizable
   */
class StateLabel extends StatelessWidget {
  
  final EdgeInsets margin;
  final double height;
  final double width;
  
  final ItemState state;

  const StateLabel({Key? key,required this.margin, required this.height, required this.width, required this.state}): super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container (
      margin: margin,
      height: this.height,
      width: this.width,
      color: getBackgroundColor(),
      child: Center(
        child: getIcon()
      )
    );

  }

  getBackgroundColor(){
    switch(this.state) {
      case ItemState.DEAL_WAITING:
        return lightGrey;
      case ItemState.DEAL_WON:
        return lightGreen;
      case ItemState.DEAL_LOST:
        return lightRed;
    }
  }

  getIcon() {
    switch(this.state) {
      case ItemState.DEAL_WAITING:
        return Icon(Icons.hourglass_top, size: 15);
      case ItemState.DEAL_WON:
        return Icon(Icons.check_box, size: 15);
      case ItemState.DEAL_LOST:        
        return Icon(Icons.cancel_rounded, size: 15);
    }
  }

}