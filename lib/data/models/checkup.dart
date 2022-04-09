import 'package:flutter/cupertino.dart';
import 'package:for_you_flutter/constants/constant_values.dart';

class Checkup {
  int id;
  String name;
  int numberAttach;
  List<String> checkupAttach;
  // List<DateTime> checkupDateTime;

  Checkup(
      {required this.id,
      required this.numberAttach,
      required this.checkupAttach,
      required this.name});

  factory Checkup.fromJson(Map<String, dynamic> json, String id) => Checkup(
        id: int.parse(id),
        name: json["name"],
        numberAttach: ConstantValues.checkupList.firstWhere((element) => element.id==int.parse(id)).numberAttach,
        checkupAttach: List<String>.from(json["checkupAttach"]),
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "name": name,
      "checkupAttach": checkupAttach,
    };
  }
}
