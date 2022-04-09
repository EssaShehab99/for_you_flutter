import 'package:flutter/cupertino.dart';
import 'package:for_you_flutter/data/models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/checkup.dart';
import '../models/hospital.dart';

class HospitalManager extends ChangeNotifier{
  List<Hospital>  _hospitalList=[];
  bool isCloud=false;

  List<Hospital> get hospitalList => _hospitalList;

  void checkHospital(int id,LatLng? latLng){

    _hospitalList[this._hospitalList.indexWhere((element) => id==element.id)].isChecked=true;
    _hospitalList[this._hospitalList.indexWhere((element) => id==element.id)].location=latLng;
  }
  void setItems(List<Hospital> hospital){
    this._hospitalList.addAll(hospital);
  }
  void setCheck(int index,bool value){
    _hospitalList[index].isChecked=value;
    notifyListeners();
  }
}