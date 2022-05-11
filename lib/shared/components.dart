// import 'dart:io'as IO;

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:for_you_flutter/constants/constant_images.dart';
import 'package:for_you_flutter/constants/constant_values.dart';
import 'package:for_you_flutter/data/providers/user_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../styles/colors_app.dart';
import 'locale_switch.dart';

class Components {
  static Future<void> launchUrl(String url, {bool call = false}) async {
    if (await (call ? canLaunch("tel: $url") : canLaunch(url))) {
      await launch(call ? "tel: $url" : url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Widget MainButton(
          {List<Widget>? children, GestureTapCallback? onTap}) =>
      Container(
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
            onTap: onTap,
            focusColor: ColorsApp.white.withOpacity(0.0),
            highlightColor: ColorsApp.white.withOpacity(0.0),
            overlayColor:
                MaterialStateProperty.all(Colors.white.withOpacity(0.0)),
            child: Padding(
              padding: EdgeInsets.all(ConstantValues.padding * 0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children ?? [],
              ),
            )),
      );

  static Widget homeCard(
          {String? text, String? icon, GestureTapCallback? onTap}) =>
      InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(ConstantValues.padding * 0.5),
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: ColorsApp.white,
              boxShadow: [
                BoxShadow(
                    color: ColorsApp.shadow, blurRadius: 5, spreadRadius: 1)
              ]),
          padding: EdgeInsets.only(left: ConstantValues.padding * 0.5),
          child: Column(
            children: [
              icon != null
                  ? Expanded(flex: 2,child: Padding(
                    padding:  EdgeInsets.all(ConstantValues.padding*0.5),
                    child: SvgPicture.asset(icon),
                  ))
                  : SizedBox.shrink(),
              Expanded(
                  child: Center(
                      child: Builder(
                          builder: (context) => Text(
                                text ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                        color: ColorsApp.primary, fontSize: 15),
                              ))))
            ],
          ),
        ),
      );

  static Future<File?> selectFile({List<String>? allowedExtensions}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions ?? ['jpg', 'png']);

    if (result != null) {
      return File(result.files.single.path!);
    } else {
      return null;
    }
  }

  static Widget bodyScreens(List<Widget> children) => SingleChildScrollView(
        padding: EdgeInsets.all(ConstantValues.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: LocaleSwitch(),
            ),
            Flexible(
                child: SizedBox(
              height: 50,
            )),
            Flexible(
                flex: 3,
                child: Center(
                  child: SvgPicture.asset(
                    ConstantImage.logo,
                    width: double.infinity,
                    height: 200,
                  ),
                )),
            Flexible(
                child: SizedBox(
              height: 50,
            )),
            for (Widget child in children) child
          ],
        ),
      );

  static Future<void> showCustomDialog(
      {required BuildContext context,
      required List<Widget> children,
      bool? barrierDismissible}) async {
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible ?? true,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          );
        });
  }

  static Future<void> checkPermission(BuildContext context) async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        // return;
      }
    }

    location.getLocation().then((value) {
      if (value.latitude != null && value.longitude != null)
        Provider.of<UserManager>(context, listen: false).setLocation(
            LatLng(value.latitude!, value.longitude!));
    });
  }
}

enum OperationType{Add,Edit}