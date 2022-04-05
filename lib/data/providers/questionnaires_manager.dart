import 'package:flutter/cupertino.dart';

import '../models/questionnaire.dart';

class QuestionnairesManager extends ChangeNotifier{
  List<Questionnaire>  _questionnaireList=[];

  void updateItem(Questionnaire questionnaire){
    _questionnaireList[this._questionnaireList.indexWhere((element) => questionnaire.id==element.id)]=questionnaire;
  }
  void setItems(List<Questionnaire> questionnaire){
    this._questionnaireList.addAll(questionnaire);
  }
}