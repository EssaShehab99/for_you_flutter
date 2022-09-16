import 'package:cloud_firestore/cloud_firestore.dart';
import '/constants/constant_values.dart';

class FileAndDate {
  DateTime dateTime;
  String file;

  FileAndDate({required this.file, required this.dateTime});

  factory FileAndDate.fromJson(Map<String, dynamic> json) => FileAndDate(
      file: json["file"]??'', dateTime: json["dateTime"]!=null?(json["dateTime"] as Timestamp).toDate():DateTime.now());

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "file": file,
      "dateTime": dateTime,
    };
  }
}

class Checkup {
  int id;
  String name;
  int numberAttach;
  List<FileAndDate> checkupAttach;

  Checkup(
      {required this.id,
      required this.numberAttach,
      required this.checkupAttach,
      required this.name});

  factory Checkup.fromJson(Map<String, dynamic> json, String id) => Checkup(
        id: int.parse(id),
        name: ConstantValues.checkupList.firstWhere((element) => element.id==int.parse(id)).name,
        numberAttach: ConstantValues.checkupList
            .firstWhere((element) => element.id == int.parse(id))
            .numberAttach,
        checkupAttach: List<FileAndDate>.from(((json["checkupAttach"] as List))
            .map((e) => FileAndDate.fromJson(e))),
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "checkupAttach": checkupAttach.map((e) => e.toJson()).toList(),
    };
  }
}
