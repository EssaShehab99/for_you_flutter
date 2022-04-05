enum QuestionnaireType { none, field, button , dropdown }

class Questionnaire{
  int? id;
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
        required  this.questionnaireType,
          this.hint,
          this.items,
         this.answerAttach});
}