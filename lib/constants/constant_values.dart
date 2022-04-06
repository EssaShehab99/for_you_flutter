import 'package:easy_localization/easy_localization.dart';

import '../data/models/checkup.dart';
import '../data/models/hospital.dart';
import '../data/models/questionnaire.dart';

class ConstantValues{
  static double padding=20.0;

  static List<Questionnaire>  questionnaireList=[
    Questionnaire(id:1,question: "q-1".tr(), questionnaireType: QuestionnaireType.field, hint: "chronic-diseases".tr()),
    Questionnaire(id:2,question: "q-2".tr(), questionnaireType: QuestionnaireType.button, hint: "attach-report".tr()),
    Questionnaire(id:3,question: "q-3".tr(), questionnaireType: QuestionnaireType.none,),
    Questionnaire(id:4,question: "q-4".tr(), questionnaireType: QuestionnaireType.field,hint: "surgeries".tr()),
    Questionnaire(id:5,question: "q-5".tr(), questionnaireType: QuestionnaireType.none,),
    Questionnaire(id:6,question: "q-6".tr(), questionnaireType: QuestionnaireType.none,),
    Questionnaire(id:7,question: "q-8".tr(), questionnaireType: QuestionnaireType.dropdown,hint: "shortness-breath".tr(),items: ["yes".tr(),"no".tr(),"often".tr(),"rarely".tr()]),
    Questionnaire(id:8,question: "q-9".tr(), questionnaireType: QuestionnaireType.none,),
    Questionnaire(id:9,question: "q-10".tr(), questionnaireType: QuestionnaireType.none,),
    Questionnaire(id:10,question: "q-11".tr(), questionnaireType: QuestionnaireType.dropdown,hint: "shortness-breath".tr(),items: ["TODO".tr(),]),
    Questionnaire(id:11,question: "q-12".tr(), questionnaireType: QuestionnaireType.none,),
  ];
  static List<Checkup>  checkupList=[
    Checkup(id: 1,name: "medical-tests".tr(),numberAttach: 2, checkupAttach: []),
    Checkup(id: 2,name: "medical-reports".tr(),numberAttach: 2, checkupAttach: []),
    Checkup(id: 3,name: "medicines-taken".tr(),numberAttach: 3, checkupAttach: []),
    ];

  static List<Hospital>  hospitalsList=[
    Hospital(id: 1,name: "hospital-1".tr(),isChecked: false),
    Hospital(id: 1,name: "hospital-2".tr(),isChecked: false),
    Hospital(id: 1,name: "hospital-3".tr(),isChecked: false),
    Hospital(id: 1,name: "hospital-4".tr(),isChecked: false),
    Hospital(id: 1,name: "hospital-5".tr(),isChecked: false),
    Hospital(id: 1,name: "hospital-6".tr(),isChecked: false),
    Hospital(id: 1,name: "hospital-7".tr(),isChecked: false),
    Hospital(id: 1,name: "hospital-8".tr(),isChecked: false),
    Hospital(id: 1,name: "another".tr(),isChecked: false),
    ];
}