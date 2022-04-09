import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:for_you_flutter/data/models/user.dart' as UserModel;
import 'package:for_you_flutter/data/providers/user_manager.dart';

class SignInDAO extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('user');


  Future<UserModel.User?> signIn(String phone, String password) async {
    UserModel.User? user;
    try {
      await collection.doc(phone).get().then((value) {
        if ((value.data() as Map<String, dynamic>)["password"] == password) {
          user = UserModel.User.fromJson(value.data() as Map<String, dynamic>);
        }
      });
    } catch (e) {}
    return user;
  }

}
