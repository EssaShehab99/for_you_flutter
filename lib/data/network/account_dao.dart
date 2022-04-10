import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:for_you_flutter/constants/constant_values.dart';
import 'package:for_you_flutter/data/models/questionnaire.dart';
import 'package:for_you_flutter/data/providers/user_manager.dart';

import '../models/checkup.dart';
import '../models/hospital.dart';

class AccountDAO extends ChangeNotifier {
  late DocumentReference documentReference;
  final storageRef = FirebaseStorage.instance.ref();
  UserManager? userManager;

  AccountDAO({this.userManager}) {
    documentReference = FirebaseFirestore.instance
        .collection('user/')
        .doc("${userManager!.getUser!.phone}");
  }

  Future<bool> setQuestionnaire(List<Questionnaire> questionnaires) async {
    bool status = false;
    try {
      for (Questionnaire questionnaire in questionnaires) {
        if (questionnaire.questionnaireType == QuestionnaireType.button &&
            questionnaire.answerAttach != null)
          questionnaires[questionnaires.indexOf(questionnaire)].answerAttach =
              await uploadFile(File(questionnaire.answerAttach!),
                  userManager!.getUser!.phone);

        await documentReference
            .collection("questionnaire")
            .doc(questionnaire.id.toString())
            .set(questionnaire.toJson())
            .whenComplete(() {
          if (questionnaires.last == questionnaire) {
            status = true;
          }
        });
      }

      /*
      questionnaires.forEach((questionnaire) async {
        if (questionnaire.questionnaireType == QuestionnaireType.button &&
            questionnaire.answerAttach != null)
          questionnaires[questionnaires.indexOf(questionnaire)].answerAttach =
              await uploadFile(File(questionnaire.answerAttach!),
                  userManager!.getUser!.phone);

        await documentReference
            .collection("questionnaire")
            .doc(questionnaire.id.toString())
            .set(questionnaire.toJson());
        if(questionnaires.last==questionnaire) {
          status = true;
        }
      });*/
    } catch (e) {
      status = false;
    }
    return status;
  }

  Future<String> uploadFile(File file, String path) async {
    String url = "";
    Reference reference = storageRef
        .child("$path/${DateTime.now()}-${file.path.split("/").last}");
    // storageRef.child("$path/${file.path.split("/").last}");
    UploadTask uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() async {
      url = await reference.getDownloadURL();
    });
    return url;
  }

  Future<bool> setCheckup(List<Checkup> checkupList) async {
    bool status = false;
    try {
      for (Checkup checkup in checkupList) {
        for (FileAndDate element in checkup.checkupAttach) {
          checkup.checkupAttach[checkup.checkupAttach.indexOf(element)].file =
              await uploadFile(File(element.file), userManager!.getUser!.phone);
        }
        await documentReference
            .collection("checkup")
            .doc(checkup.id.toString())
            .set(checkup.toJson())
            .then((value) {
          status = true;
        });
      }
    } catch (e) {}

    return status;
  }

  Future<bool?> setHospitals(List<Hospital> hospitalList) async {
    bool status = false;

    try {
      for (var hospital in hospitalList) {
        if (hospital.isChecked) {
          await documentReference
              .collection("hospitals")
              .doc(hospital.id.toString())
              .set(hospital.toJson())
              .then((value) {
            status = true;
          });
        }
      }
    } catch (e) {}

    return status;
  }

  Future<void> setInformation(
      {required List<Hospital> hospitalList,
      required List<Checkup> checkupList,
      required List<Questionnaire> questionnaires}) async {
    await setQuestionnaire(questionnaires);
    await setCheckup(checkupList);
    await setHospitals(hospitalList);

    return Future.value();
  }

  Future<List<Questionnaire>> getQuestionnaires() async {
    List<Questionnaire> _questionnaireList = [];

    await documentReference.collection("questionnaire").get().then((value) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot in value.docs) {
        _questionnaireList
            .add(Questionnaire.fromJson(snapshot.data(), snapshot.id));
      }
    });
    return _questionnaireList;
  }

  Future<bool> updateQuestionnaires(List<Questionnaire> questionnaires) async {
    bool status = false;
    try {
      for (Questionnaire questionnaire in questionnaires) {
        if (questionnaire.questionnaireType == QuestionnaireType.button &&
            questionnaire.answerAttach != null &&
            await File(questionnaire.answerAttach!).exists())
          questionnaires[questionnaires.indexOf(questionnaire)].answerAttach =
              await uploadFile(File(questionnaire.answerAttach!),
                  userManager!.getUser!.phone);

        await documentReference
            .collection("questionnaire")
            .doc(questionnaire.id.toString())
            .update(questionnaire.toJson())
            .whenComplete(() {
          if (questionnaires.last == questionnaire) {
            status = true;
          }
        });
      }
    } catch (e) {}
    return status;
  }

  Future<List<Checkup>> getCheckups() async {
    List<Checkup> _checkupList = [];

    await documentReference.collection("checkup").get().then((value) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot in value.docs) {
        _checkupList.add(Checkup.fromJson(snapshot.data(), snapshot.id));
      }
    });
    return _checkupList;
  }

  Future<bool> updateCheckups(List<Checkup> checkupList) async {
    bool status = false;
    try {
      for (Checkup checkup in checkupList) {
        for (FileAndDate element in checkup.checkupAttach) {
          if (await File(element.file).exists())
            checkup.checkupAttach[checkup.checkupAttach.indexOf(element)].file =
                await uploadFile(File(element.file), userManager!.getUser!.phone);
        }
        await documentReference
            .collection("checkup")
            .doc(checkup.id.toString())
            .update(checkup.toJson())
            .then((value) {
          status = true;
        });
      }
    } catch (e) {}

    return status;
  }

  Future<List<Hospital>> getHospitals() async {
    List<Hospital> _hospitalList = [];

    await documentReference.collection("hospitals").get().then((value) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot in value.docs) {
        _hospitalList.add(Hospital.fromJson(snapshot.data(), snapshot.id));
      }
    });
    return _hospitalList;
  }

  Future<bool> updateHospitals(List<Hospital> hospitalList) async {
    bool status = false;

    await deleteHospitals();
    await setHospitals(hospitalList);

    return status;
  }
  Future<bool> deleteHospitals() async {
    bool status = false;
    try {
      for (var hospital in ConstantValues.hospitalsList) {
          await documentReference
              .collection("hospitals")
              .doc(hospital.id.toString())
              .delete()
              .then((value) {
            status = true;
          });

      }
    } catch (e) {}

    return status;
  }
}
