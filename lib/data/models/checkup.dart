import 'package:flutter/cupertino.dart';

class Checkup {
  int id;
  String? docID;
  String name;
  int numberAttach;
  List<String> checkupAttach;

  Checkup({required this.id, this.docID, required this.numberAttach,  required this.checkupAttach,  required this.name});
}
