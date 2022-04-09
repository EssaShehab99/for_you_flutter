import 'package:flutter/cupertino.dart';

import '../models/questionnaire.dart';

class QuestionnairesManager extends ChangeNotifier{
  List<Questionnaire>  _questionnaireList=[];
  List<Questionnaire> get questionnaireList => _questionnaireList;
  bool isCloud=false;
  void updateItem(Questionnaire questionnaire){
    _questionnaireList[this._questionnaireList.indexWhere((element) => questionnaire.id==element.id)]=questionnaire;
  }
  void setItems(List<Questionnaire> questionnaire){
    _questionnaireList.clear();
    this._questionnaireList.addAll(questionnaire);
    orderList();
    notifyListeners();
  }
  void orderList(){
    _questionnaireList.sort((a, b) {
      return a.id.compareTo(b.id);
    });
  }

}