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
import '../data/models/questionnaire.dart';
import '../shared/components.dart';
import '../shared/locale_switch.dart';

class QuestionnairesScreen extends StatelessWidget {
  QuestionnairesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String hint="attach-report".tr();
    return SafeArea(
      child: Scaffold(
        body: Components.bodyScreens([
          Flexible(
              child: Center(
                child: Text(
                  "welcome".tr()+" "+Provider.of<UserManager>(context,listen: false).getUser!.name,style: Theme.of(context).textTheme.headline1,
                ),
              )),
          Flexible(
              child: SizedBox(
                height: 50,
              )),
          for(Questionnaire item in ConstantValues.questionnaireList)
            Flexible(
                child:QuestionnaireCard(
                  questionnaire: item,
                  onChangedRadio: (SingingCharacter? value) {
                    print(value);
                  },
                )),
          Components.MainButton(
              children: [
                Text(
                  "next".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: ColorsApp.white),
                )
              ],
              onTap: () {}),
          Components.MainButton(
              children: [
                Text(
                  "previous".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: ColorsApp.white),
                )
              ],
              onTap: () {
                Navigator.pop(context);
              }),
        ]),
      ),
    );
  }
}
