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
              Flexible(
                  child: buildColumn(
                      textOne: "beneficiaries".tr(),
                      imageOne: ConstantImage.iconOne,
                      textTwo: "personal-information".tr(),
                      imageTow: ConstantImage.iconTwo)),
              Flexible(
                  child: buildColumn(
                      textOne: "medical-examinations".tr(),
                      imageOne: ConstantImage.iconThree,
                      textTwo: "medical-history".tr(),
                      imageTow: ConstantImage.iconFour)),
              Flexible(
                  child: buildColumn(
                      textOne: "hospital-network".tr(),
                      imageOne: ConstantImage.iconFive,
                      textTwo: "phone".tr(),
                      imageTow: ConstantImage.iconSix)),
              Flexible(child: Components.MainButton(
                  children: [
                    Text(
                      "log-out".tr(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: ColorsApp.white),
                    )
                  ],
                  onTap: () {
                  }),)
            ],
          ),
        ),
      ),
    );
  }

  Column buildColumn(
      {required String textOne,
      required String imageOne,
      required String textTwo,
      required String imageTow}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Row(
            children: [
              Expanded(
                child: Components.homeCard(text: textOne, icon: imageOne),
              ),
              Expanded(
                child: Components.homeCard(text: textTwo, icon: imageTow),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
