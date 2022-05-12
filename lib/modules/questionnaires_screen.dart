import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_you_flutter/data/network/account_dao.dart';
import 'package:for_you_flutter/data/providers/user_manager.dart';
import 'package:for_you_flutter/styles/colors_app.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

import '../constants/constant_images.dart';
import '../constants/constant_values.dart';
import '../data/models/questionnaire.dart';
import '../data/providers/questionnaires_manager.dart';
import '../shared/components.dart';
import '../shared/custom_button.dart';
import '../shared/dropdown_input.dart';
import '../shared/locale_switch.dart';
import '../shared/text_input.dart';
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
                child: _QuestionnaireCard(
                  questionnaire: item,
                  isEdit: isEdit,
                  onChangedRadio: (SingingCharacter? value) {
                    print(value);
                  },
                )),
          StatefulBuilder(builder: (context, setState) {
            return
              CustomButton(
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
            CustomButton(
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

enum SingingCharacter { yes, no }

class _QuestionnaireCard extends StatefulWidget {
  const _QuestionnaireCard(
      {Key? key,
        required this.onChangedRadio,
        required this.questionnaire,
        this.isEdit = false})
      : super(key: key);
  final Questionnaire questionnaire;

  final bool isEdit;
  final ValueChanged<SingingCharacter?> onChangedRadio;

  @override
  State<_QuestionnaireCard> createState() => _QuestionnaireCardState();
}

class _QuestionnaireCardState extends State<_QuestionnaireCard> {
  SingingCharacter? _character = SingingCharacter.yes;
  late TextEditingController textEditingController;
  String? hint;

  @override
  void initState() {
    textEditingController = TextEditingController();
    hint = widget.questionnaire.hint;
    if (widget.isEdit && widget.questionnaire.answer != null) {
      _character = widget.questionnaire.answer!
          ? SingingCharacter.yes
          : SingingCharacter.no;
    }
    if(widget.questionnaire.questionnaireType==QuestionnaireType.field&& widget.questionnaire.answerAttach!=null)
      textEditingController.text=widget.questionnaire.answerAttach!;
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // if(!widget.isEdit){
    QuestionnairesManager questionnairesManager =
    Provider.of<QuestionnairesManager>(context);
    textEditingController.addListener(() {
      widget.questionnaire.answerAttach = textEditingController.text;
    });
    widget.questionnaire.answer =
    _character == SingingCharacter.yes ? true : false;
    questionnairesManager.updateItem(widget.questionnaire);
    // }
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
              flex: 2,
              child: Text(
                widget.questionnaire.question,
                style: Theme.of(context).textTheme.headline1,
              )),
          if (widget.questionnaire.questionnaireType !=
              QuestionnaireType.dropdown)
            Flexible(
                flex: 2,
                child: Row(
                  children: [
                    Flexible(
                      child: RadioListTile<SingingCharacter>(
                        title: Text('yes'.tr()),
                        value: SingingCharacter.yes,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                    Flexible(
                      child: RadioListTile<SingingCharacter>(
                        title: Text('no'.tr()),
                        value: SingingCharacter.no,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                  ],
                )),
          if (widget.questionnaire.questionnaireType == QuestionnaireType.none)
            SizedBox.shrink(),
          if (widget.questionnaire.questionnaireType == QuestionnaireType.field)
            Flexible(
                flex: 3,
                child: TextInput(
                  controller: textEditingController,
                  hint: widget.questionnaire.hint,
                )),
          if (widget.questionnaire.questionnaireType ==
              QuestionnaireType.button)
            Flexible(
              flex: 3,
              child: Row(
                children: [
                  Flexible(
                      child:
                      CustomButton(
                          children: [
                            Flexible(
                                child: Text(hint!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(color: ColorsApp.white)))
                          ],
                          onTap: () {
                            Components.selectFile().then((value) {
                              if (value != null) {
                                setState(() {
                                  widget.questionnaire.isLocale = true;
                                  widget.questionnaire.answerAttach =
                                      value.path;
                                });
                              }
                            });
                          }),),
                  widget.questionnaire.answerAttach != null
                      ? Flexible(
                      flex: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ConstantValues.padding * 0.5),
                        child: InkWell(
                          onTap: () async {
                            widget.questionnaire.isLocale
                                ? await OpenFile.open(
                                widget.questionnaire.answerAttach)
                                : Components.launchUrl(
                                widget.questionnaire.answerAttach!);
                          },
                          child: widget.questionnaire.isLocale
                              ? Image.file(
                            File(widget.questionnaire.answerAttach!),
                            width: 50,
                          )
                              : Image.network(
                            widget.questionnaire.answerAttach!,
                            width: 50,
                          ),
                        ),
                      ))
                      : SizedBox.shrink(),
                ],
              ),
            ),
          if (widget.questionnaire.questionnaireType ==
              QuestionnaireType.dropdown)
            Flexible(
                flex: 3,
                child: DropdownInput(
                  items: widget.questionnaire.items,
                  hint: widget.questionnaire.hint,
                  onChanged: (value) {
                    setState(() {
                      widget.questionnaire.answerAttach = value;
                    });
                  },
                )),
        ],
      ),
    );
  }
}

