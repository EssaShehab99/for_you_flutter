import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:for_you_flutter/data/models/questionnaire.dart';
import 'package:for_you_flutter/data/models/user.dart' as UserModel;
import 'package:for_you_flutter/data/providers/user_manager.dart';

class AccountDAO extends ChangeNotifier {
  UserManager? userManager;

  AccountDAO({this.userManager}) {

    documentReference = FirebaseFirestore.instance
        .collection('user/').doc("${userManager!.getUser!.phone}");
  }

  late DocumentReference documentReference;

  Future<void> setQuestionnaire(List<Questionnaire> questionnaires) async {
    questionnaires.forEach((questionnaire) {
      documentReference.collection("questionnaire").doc(questionnaire.id.toString()).set(questionnaire.toJson());
    });

  }
}
