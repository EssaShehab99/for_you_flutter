import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:for_you_flutter/data/models/user.dart' as UserModel;
import 'package:for_you_flutter/data/providers/user_manager.dart';

class SignUpDAO extends ChangeNotifier {
  SignUpDAO({this.user});
  FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('user');

  UserModel.User? user;
  String? verificationId;

  Future<void> signUp() async {
    if (user != null) return collection.doc(user!.phone).set(user!.toJson());
  }



  Future<void> verifyPhone({
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    if (user != null)
      await auth.verifyPhoneNumber(
        phoneNumber: user!.phone,
        timeout: Duration(seconds: UserManager.DURATION_TIME_OUT),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    return Future.value();
  }

  Future<void> verificationCode(
      {required String smsCode,
      required Function onClick,
      required Function onFailed,
      required Function onSuccess}) async {
    try {
      onClick();
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId!, smsCode: smsCode);
      await auth.signInWithCredential(credential).then((value) {
        onSuccess();
        signUp();
      });
    } catch (_) {
      onFailed();
    }
  }

  Future<void> updateUser(UserModel.User user) async {
    await collection.doc(user.phone).update(user.toJson());
    return Future.value();
  }
}
