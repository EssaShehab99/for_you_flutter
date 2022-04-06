import 'package:flutter/cupertino.dart';
import 'package:for_you_flutter/data/models/user.dart';

import '../models/checkup.dart';
import '../models/hospital.dart';

class HospitalManager extends ChangeNotifier{
  List<Hospital>  _hospitalList=[];

  List<Hospital> get hospitalList => _hospitalList;

  void updateItem(Hospital hospitalList){
    _hospitalList[this._hospitalList.indexWhere((element) => hospitalList.id==element.id)]=hospitalList;
  }
  void initial(List<Hospital> hospital){
    this._hospitalList.addAll(hospital);
  }
  void setCheck(int index){
    _hospitalList[index].isChecked=true;
  }
}