import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String? id;
  String name;
  String phone;
  int age;
  double height;
  double weight;
  String blood;
  String socialStatus;
  String? password;
  DocumentReference? reference;

  User(
      {this.id,
      required this.name,
      required this.phone,
      required this.age,
      required this.height,
      required this.weight,
      required this.blood,
      required this.socialStatus,
       this.password});
  factory User.fromJson(Map<String, dynamic> json,String id) =>
      User(name: json["name"], phone: json["phone"], age: json["age"], height: json["height"], weight: json["weight"], blood: json["blood"], socialStatus: json["socialStatus"]);

  Map<String, dynamic> toJson() => <String, dynamic>{
    "id":id,
    "name":name,
    "phone":phone,
    "age":age,
    "height":height,
    "weight":weight,
    "blood":blood,
    "socialStatus":socialStatus,
    "password":password
  };
  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final user = User.fromJson(snapshot.data() as
    Map<String, dynamic>,snapshot.id);
    user.reference = snapshot.reference;
    return user;
  }
}