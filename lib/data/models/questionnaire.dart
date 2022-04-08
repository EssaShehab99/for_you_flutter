enum QuestionnaireType { none, field, button, dropdown }

class Questionnaire {
  int id;
  String? docID;
  String question;
  String? hint;
  bool? answer;
  String? answerAttach;
  QuestionnaireType questionnaireType;
  List<String>? items;

  Questionnaire(
      {required this.id,
      required this.question,
      this.docID,
      this.answer,
      required this.questionnaireType,
      this.hint,
      this.items,
      this.answerAttach});

  factory Questionnaire.fromJson(Map<String, dynamic> json, String id) =>
      Questionnaire(
        id: int.parse(id),
        question: json["question"],
        docID: json["docID"],
        questionnaireType: json["questionnaireType"],
        hint: json["hint"],
        items: json["items"],
        answerAttach: json["answerAttach"],
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "answer": answer,
      "questionnaireType": questionnaireType.index,
      "answerAttach": answerAttach
    };
  }
}
