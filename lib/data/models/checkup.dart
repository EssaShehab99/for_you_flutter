import 'package:flutter/cupertino.dart';

class Checkup {
  int id;
  String name;
  int numberAttach;
  List<String> checkupAttach;

  Checkup({required this.id, required this.numberAttach,  required this.checkupAttach,  required this.name});

  factory Checkup.fromJson(Map<String, dynamic> json, String id) =>
      Checkup(
        id: int.parse(id),
        name: json["name"],
        numberAttach: (json["checkupAttach"] as List<String>).length,
        checkupAttach: json["checkupAttach"],
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "name": name,
      "checkupAttach": checkupAttach,
    };
  }
}
