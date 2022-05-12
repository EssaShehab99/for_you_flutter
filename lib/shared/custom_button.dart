import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constant_values.dart';
import '../styles/colors_app.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {Key? key, this.onTap, required this.children, this.isLoading = false})
      : super(key: key);
  final List<Widget>? children;
  final GestureTapCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: EdgeInsets.only(top: ConstantValues.padding * 0.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: ColorsApp.primary,
          boxShadow: [
            BoxShadow(color: ColorsApp.shadow, blurRadius: 1, spreadRadius: 1)
          ]),
      padding: EdgeInsets.only(left: ConstantValues.padding * 0.5),
      child: InkWell(
          onTap: isLoading ? null : onTap,
          focusColor: ColorsApp.white.withOpacity(0.0),
          highlightColor: ColorsApp.white.withOpacity(0.0),
          overlayColor:
              MaterialStateProperty.all(Colors.white.withOpacity(0.0)),
          child: Padding(
            padding: EdgeInsets.all(ConstantValues.padding * 0.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: isLoading
                  ? [
                      CircularProgressIndicator(
                        color: ColorsApp.white,
                      )
                    ]
                  : children ?? [],
            ),
          )),
    );
  }
}
