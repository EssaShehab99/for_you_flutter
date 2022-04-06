import 'package:flutter/cupertino.dart';
import 'package:for_you_flutter/data/models/user.dart';

class UserManager extends ChangeNotifier{
User? _user;

User? get getUser => _user;

  void setUser(User user){
  this._user=user;
}
}