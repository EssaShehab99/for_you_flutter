import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../styles/colors_app.dart';

class Components {
  static Widget MainButton(
          {List<Widget>? children, GestureTapCallback? onTap}) =>
      Container(
        height: 56,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: ColorsApp.primary,
            boxShadow: [
              BoxShadow(color: ColorsApp.shadow, blurRadius: 1, spreadRadius: 1)
            ]),
        padding: EdgeInsets.only(left: 10),
        child: InkWell(
            onTap: onTap,
            focusColor: ColorsApp.white.withOpacity(0.0),
            highlightColor: ColorsApp.white.withOpacity(0.0),
            overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(0.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children ?? [],
            )),
      );
}
