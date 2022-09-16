import 'package:flutter/cupertino.dart';

import '../models/checkup.dart';

class CheckupManager extends ChangeNotifier{
  List<Checkup>  _checkupList=[];
  bool isCloud=false;

  List<Checkup> get checkupList => _checkupList;

  void updateItem(Checkup checkup){
    _checkupList[this._checkupList.indexWhere((element) => checkup.id==element.id)]=checkup;
  }
  void setItems(List<Checkup> checkup){
    _checkupList.clear();
    this._checkupList.addAll(checkup);
  }

}