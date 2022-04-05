import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_you_flutter/shared/custom_card.dart';
import 'package:for_you_flutter/styles/colors_app.dart';

import '../constants/constant_images.dart';
import '../constants/constant_values.dart';
import '../data/models/questionnaire.dart';
import '../shared/components.dart';
import '../shared/locale_switch.dart';
import '../shared/text_input.dart';

class QuestionnairesScreen extends StatelessWidget {
  QuestionnairesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String hint="attach-report".tr();
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
              for(Questionnaire item in ConstantValues.questionnaireList)
              Flexible(
                  child:CustomCard(
                    questionnaire: item,
                    onChangedRadio: (SingingCharacter? value) {
                      print(value);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
