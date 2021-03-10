import 'package:flutter/widgets.dart';

class SizeConfig {
  MediaQueryData _mediaQueryData;
  double screenWidth;
  double screenHeight;
  double blockSizeHorizontal;

  MediaQueryData get mediaQueryData => _mediaQueryData;
  double blockSizeVertical;
  double _safeAreaHorizontal;
  double _safeAreaVertical;
  double safeBlockHorizontal;
  double safeBlockVertical;

  void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth/100;
    blockSizeVertical = screenHeight/100;
    _safeAreaHorizontal = _mediaQueryData.padding.left +
        _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top +
        _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal)/100;
    safeBlockVertical = (screenHeight - _safeAreaVertical)/100;
  }

  double get safeAreaHorizontal => _safeAreaHorizontal;

  double get safeAreaVertical => _safeAreaVertical;
}
//comments