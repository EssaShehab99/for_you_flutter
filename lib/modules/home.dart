import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_you_flutter/data/providers/user_manager.dart';
import 'package:for_you_flutter/shared/questionnaire_card.dart';
import 'package:for_you_flutter/styles/colors_app.dart';
import 'package:provider/provider.dart';

import '../constants/constant_images.dart';
import '../constants/constant_values.dart';
import '../data/models/checkup.dart';
import '../data/models/questionnaire.dart';
import '../shared/checkup_card.dart';
import '../shared/components.dart';
import '../shared/locale_switch.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
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
              Flexible(
                  child: Center(
                child: Text(
                  "welcome".tr() +
                      " " +
                      Provider.of<UserManager>(context, listen: false)
                          .getUser!
                          .name,
                  style: Theme.of(context).textTheme.headline1,
                ),
              )),
              Flexible(
                  child: SizedBox(
                height: 50,
              )),

            ],
          ),
        ),
      ),
    );
  }
}
