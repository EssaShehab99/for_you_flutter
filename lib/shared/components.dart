// import 'dart:io'as IO;

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:for_you_flutter/constants/constant_values.dart';

import '../styles/colors_app.dart';

class Components {
  static Widget MainButton(
          {List<Widget>? children, GestureTapCallback? onTap}) =>
      Container(
        height: 56,
        margin: EdgeInsets.only(top: ConstantValues.padding*0.5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: ColorsApp.primary,
            boxShadow: [
              BoxShadow(color: ColorsApp.shadow, blurRadius: 1, spreadRadius: 1)
            ]),
        padding: EdgeInsets.only(left: ConstantValues.padding*0.5),
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

  static Future<File?> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['jpg', 'png']);

    if (result != null) {
     return  File(result.files.single.path!) ;
    } else {
      return null;
    }
  }
}
