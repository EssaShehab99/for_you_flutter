import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_you_flutter/data/providers/checkup_manager.dart';
import 'package:for_you_flutter/data/providers/hospitals_manager.dart';
import 'package:for_you_flutter/data/providers/questionnaires_manager.dart';
import 'package:for_you_flutter/shared/components.dart';
import 'package:for_you_flutter/shared/text_input.dart';
import 'package:provider/provider.dart';

import '../constants/constant_values.dart';
import '../data/models/checkup.dart';
import '../data/models/questionnaire.dart';
import '../styles/colors_app.dart';
import 'dropdown_input.dart';

class AssociatedCard extends StatefulWidget {
  const AssociatedCard({
    Key? key,
  }) : super(key: key);

  @override
  State<AssociatedCard> createState() => _AssociatedCardState();
}

class _AssociatedCardState extends State<AssociatedCard> {
  bool isAnother = false;
  late TextEditingController anotherController;
  late HospitalManager hospitalManager;

  @override
  void initState() {
    hospitalManager = Provider.of<HospitalManager>(context, listen: false);
    anotherController = TextEditingController();
    if(hospitalManager.hospitalList[8].isChecked){
      anotherController.text=hospitalManager.hospitalList[8].name!;
      anotherController.addListener(() {
        // if(anotherController.text!=null)
        hospitalManager.setHospitalName(9, anotherController.text);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    anotherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isAnother=hospitalManager.hospitalList[8].isChecked;
    if(hospitalManager.hospitalList[8].isChecked)
    anotherController.text=hospitalManager.hospitalList[8].name!;

    return Container(
      height: 175,
      width: double.infinity,
      padding: EdgeInsets.all(ConstantValues.padding),
      margin: EdgeInsets.only(top: ConstantValues.padding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: ColorsApp.white,
          boxShadow: [
            BoxShadow(color: ColorsApp.shadow, blurRadius: 1, spreadRadius: 1)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              child: DropdownInput(
            width: 200,
            isCheckBox: true,
            onCheckBox: (List<bool> list) {
              for (int i = 0; i < list.length; i++) {
                if (list[i] == true) {
                  Provider.of<HospitalManager>(context, listen: false)
                      .setCheck(i, true);
                } else {
                  Provider.of<HospitalManager>(context, listen: false)
                      .setCheck(i, false);
                }
              }
              setState(() {
                if (list[8] == true)
                  isAnother = true;
                else
                  isAnother = false;
              });
            },
            hint: "associated-hospitals".tr(),
            items: List<String>.generate(
                Provider.of<HospitalManager>(context, listen: false)
                    .hospitalList
                    .length,
                (index) => Provider.of<HospitalManager>(context, listen: false)
                    .hospitalList[index]
                    .name!),
          )),
          isAnother
              ? TextInput(
                  controller: anotherController,
                  hint: "associated-hospitals".tr(),
                  textInputAction: TextInputAction.done,
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
