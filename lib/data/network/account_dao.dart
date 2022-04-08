import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:for_you_flutter/data/models/questionnaire.dart';
import 'package:for_you_flutter/data/providers/user_manager.dart';

import '../models/checkup.dart';

class AccountDAO extends ChangeNotifier {
  late DocumentReference documentReference;
  final storageRef = FirebaseStorage.instance.ref();
  UserManager? userManager;

  AccountDAO({this.userManager}) {
    documentReference = FirebaseFirestore.instance
        .collection('user/')
        .doc("${userManager!.getUser!.phone}");
  }

  Future<void> setQuestionnaire(List<Questionnaire> questionnaires) async {
    questionnaires.forEach((questionnaire) {
      if (questionnaire.questionnaireType == QuestionnaireType.button&&questionnaire.answerAttach!=null)
        uploadFile(
                File(questionnaire.answerAttach!), userManager!.getUser!.phone)
            .then((value) {
          questionnaire.answerAttach = value;
          documentReference
              .collection("questionnaire")
              .doc(questionnaire.id.toString())
              .set(questionnaire.toJson());
        });
      else
        documentReference
            .collection("questionnaire")
            .doc(questionnaire.id.toString())
            .set(questionnaire.toJson());
    });
  }

  Future<String> uploadFile(File file, String path) async {
    String url = "";
    print(file.path);
    Reference reference =
        storageRef.child("$path/${file.path.split("/").last}");
    UploadTask uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() async {
      url = await reference.getDownloadURL();
    });
    return url;
  }

  Future<void> setCheckup(List<Checkup> checkupList) async {
    checkupList.forEach((checkup) {
      checkup.checkupAttach.forEach((element) async {
        checkup.checkupAttach[checkup.checkupAttach.indexOf(element)] =
            await uploadFile(File(element), userManager!.getUser!.phone);
      });
      documentReference
          .collection("checkup")
          .doc(checkup.id.toString())
          .set(checkup.toJson());
    });
  }
}
