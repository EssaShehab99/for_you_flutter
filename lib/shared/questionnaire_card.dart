import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:for_you_flutter/data/providers/questionnaires_manager.dart';
import 'package:for_you_flutter/shared/components.dart';
import 'package:for_you_flutter/shared/text_input.dart';
import 'package:provider/provider.dart';

import '../constants/constant_values.dart';
import '../data/models/questionnaire.dart';
import '../styles/colors_app.dart';
import 'dropdown_input.dart';

enum SingingCharacter { yes, no }

class QuestionnaireCard extends StatefulWidget {
  const QuestionnaireCard(
      {Key? key, required this.onChangedRadio, required this.questionnaire})
      : super(key: key);
  final Questionnaire questionnaire;

  final ValueChanged<SingingCharacter?> onChangedRadio;

  @override
  State<QuestionnaireCard> createState() => _QuestionnaireCardState();
}

class _QuestionnaireCardState extends State<QuestionnaireCard> {
  SingingCharacter? _character = SingingCharacter.yes;
  late TextEditingController textEditingController;
  String? hint;

  @override
  void initState() {
    textEditingController = TextEditingController();
    hint = widget.questionnaire.hint;
    super.initState();
  }
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    QuestionnairesManager questionnairesManager =
        Provider.of<QuestionnairesManager>(context);
    textEditingController.addListener(() {
      widget.questionnaire.answerAttach = textEditingController.text;
    });
    widget.questionnaire.answer =
        _character == SingingCharacter.yes ? true : false;
    questionnairesManager.updateItem(widget.questionnaire);
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
          if(widget.questionnaire.questionnaireType != QuestionnaireType.dropdown)
          Flexible(
              flex: 2,
              child: Row(
                children: [
                  Flexible(
                    child: RadioListTile<SingingCharacter>(
                      title:  Text('yes'.tr()),
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
                      title:  Text('no'.tr()),
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
                      child: Components.MainButton(
                          onTap: () {
                            Components.selectFile().then((value) {
                              setState(() {
                                widget.questionnaire.answerAttach = value?.path;
                              });
                            });
                          },
                          children: [
                             Flexible(
                                child: Text(hint!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(color: ColorsApp.white)))
                          ])),
                  widget.questionnaire.answerAttach!=null?   Flexible(
                      flex: 0,child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: ConstantValues.padding*0.5),
                    child: InkWell(onTap: () {

                    },child: Image.file(File(widget.questionnaire.answerAttach??""),width: 50,)),
                  )):SizedBox.shrink(),
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
