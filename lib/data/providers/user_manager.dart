import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:for_you_flutter/data/models/user.dart';

class UserManager extends ChangeNotifier {
  User? _user;
  String? activeCode;
  static int DURATION_TIME_OUT = 120;
  User? get getUser => _user;
  void setUser(User user) {
    this._user = user;
    notifyListeners();
  }

  setActiveCode(String activeCode) {
    this.activeCode=activeCode;
  }
  void signOut(){
    this._user=null;
  }
}
