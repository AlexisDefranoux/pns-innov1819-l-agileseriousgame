import 'dart:ui';

import 'package:agile_serious_game/data/color.dart';
import 'package:flutter/material.dart';

class FrozenCircularIndicatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ClipRect(
      child: new BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: new Container(
          decoration:
              new BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
          child: new Center(
            child: new CircularProgressIndicator(
              backgroundColor: Color(AppColors.themeColor),
            ),
          ),
        ),
      ),
    );
  }
}
