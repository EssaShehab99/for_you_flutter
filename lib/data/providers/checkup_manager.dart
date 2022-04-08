import 'package:flutter/cupertino.dart';
import 'package:for_you_flutter/data/models/user.dart';

import '../models/checkup.dart';

class CheckupManager extends ChangeNotifier{
  List<Checkup>  _checkupList=[];

  List<Checkup> get checkupList => _checkupList;

  void updateItem(Checkup checkup){
    _checkupList[this._checkupList.indexWhere((element) => checkup.id==element.id)]=checkup;
  }
  void setItems(List<Checkup> checkup){
    this._checkupList.addAll(checkup);
  }

}