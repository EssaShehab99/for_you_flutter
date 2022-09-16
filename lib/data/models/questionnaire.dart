import '/constants/constant_values.dart';

enum QuestionnaireType { none, field, button, dropdown }

class Questionnaire {
  int id;
  String question;
  String? hint;
  bool? answer;
  bool isLocale;
  String? answerAttach;
  QuestionnaireType questionnaireType;
  List<String>? items;

  Questionnaire(
      {required this.id,
      required this.question,
      this.answer,
      required this.questionnaireType,
      required this.isLocale,
      this.hint,
      this.items,
      this.answerAttach});

  factory Questionnaire.fromJson(Map<String, dynamic> json, String id) {
    Questionnaire questionnaire=ConstantValues.questionnaireList.firstWhere((element) => element.id==int.parse(id));
    return Questionnaire(
        id: int.parse(id),
        answer: json["answer"],
        question: questionnaire.question,
        isLocale: false,
        questionnaireType: QuestionnaireType.values.firstWhere((element) => element.index==(json["questionnaireType"] as int)),
        hint: questionnaire.hint,
        items: questionnaire.items,
        answerAttach: json["answerAttach"],
      );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "answer": answer,
      "questionnaireType": questionnaireType.index,
      "answerAttach": answerAttach
    };
  }
}
