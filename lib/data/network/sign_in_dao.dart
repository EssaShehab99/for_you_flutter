import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '/data/models/user.dart' as UserModel;

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
  Future<UserModel.User?> checkPhone(String phone) async {
    UserModel.User? user;
    try {
      await collection.doc(phone).get().then((value) {
          user = UserModel.User.fromJson(value.data() as Map<String, dynamic>);
      });
    } catch (e) {}
    return user;
  }

}
