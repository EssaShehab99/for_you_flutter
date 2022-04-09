import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_you_flutter/data/network/account_dao.dart';
import 'package:for_you_flutter/data/providers/user_manager.dart';
import 'package:for_you_flutter/shared/questionnaire_card.dart';
import 'package:for_you_flutter/styles/colors_app.dart';
import 'package:provider/provider.dart';

import '../constants/constant_images.dart';
import '../constants/constant_values.dart';
import '../data/models/questionnaire.dart';
import '../data/providers/questionnaires_manager.dart';
import '../shared/components.dart';
import '../shared/locale_switch.dart';
import 'checkups_screen.dart';

class QuestionnairesScreen extends StatelessWidget {
  QuestionnairesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isEdit = false;
    QuestionnairesManager questionnairesManager =
        Provider.of<QuestionnairesManager>(context);
    if (questionnairesManager.isCloud) {
      isEdit = true;
    }
    bool isLoading = false;

    return SafeArea(
      child: Scaffold(
        body: Components.bodyScreens([
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
          for (Questionnaire item in isEdit
              ? questionnairesManager.questionnaireList
              : ConstantValues.questionnaireList)
            Flexible(
                child: QuestionnaireCard(
              questionnaire: item,
              isEdit: isEdit,
              onChangedRadio: (SingingCharacter? value) {
                print(value);
              },
            )),
          StatefulBuilder(builder: (context, setState) {
            return Components.MainButton(
                children: [
                  isLoading
                      ? CircularProgressIndicator(
                          color: ColorsApp.white,
                        )
                      : Text(
                          isEdit ? "edit".tr() : "next".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: ColorsApp.white),
                        )
                ],
                onTap: () {
                  if (isEdit) {
                    if(!isLoading){
                      setState(() {
                        isLoading = true;
                      });
                      Provider.of<AccountDAO>(context, listen: false)
                          .updateQuestionnaires(
                              questionnairesManager.questionnaireList)
                          .whenComplete(() {
                        setState(() {
                          isLoading = false;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              "success-edit".tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(color: CupertinoColors.white),
                            ),
                          ));
                        });
                        Provider.of<AccountDAO>(context, listen: false)
                            .getQuestionnaires()
                            .then((value) {
                          questionnairesManager.setItems(value);
                          questionnairesManager.isCloud = true;
                        });
                      });
                    }
                  } else
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckupsScreen(),
                        ));
                });
          }),
          if (!isEdit)
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
