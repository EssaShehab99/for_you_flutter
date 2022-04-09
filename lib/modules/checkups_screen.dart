import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_you_flutter/data/network/account_dao.dart';
import 'package:for_you_flutter/data/providers/questionnaires_manager.dart';
import 'package:for_you_flutter/data/providers/user_manager.dart';
import 'package:for_you_flutter/shared/questionnaire_card.dart';
import 'package:for_you_flutter/styles/colors_app.dart';
import 'package:provider/provider.dart';

import '../constants/constant_images.dart';
import '../constants/constant_values.dart';
import '../data/models/checkup.dart';
import '../data/models/questionnaire.dart';
import '../data/providers/checkup_manager.dart';
import '../shared/checkup_card.dart';
import '../shared/components.dart';
import '../shared/locale_switch.dart';
import 'associated_hospitals.dart';

class CheckupsScreen extends StatelessWidget {
  CheckupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isEdit = false;
    bool isLoading = false;

    CheckupManager checkupManager = Provider.of<CheckupManager>(context);
    if (checkupManager.isCloud) {
      isEdit = true;
    }
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
          for (Checkup item in isEdit
              ? checkupManager.checkupList
              : ConstantValues.checkupList)
            Flexible(
                child: CheckupCard(
              checkup: item,
            )),
          StatefulBuilder(
            builder: (context, setState) => Components.MainButton(
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
                          .updateCheckups(checkupManager.checkupList)
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
                      });
                    }
                  } else
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssociatedHospitals(),
                        ));
                }),
          ),
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
