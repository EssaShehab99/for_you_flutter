import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String phone;
  int age;
  double height;
  double weight;
  int blood;
  int gender;
  int socialStatus;
  String password;
  DocumentReference? reference;

  static encrypt.Key key = encrypt.Key.fromUtf8('my 32 length key................');
  static encrypt.IV iv = encrypt.IV.fromLength(16);

  // var decrypted = encrypter.decrypt(encrypted, iv: iv);

  User(
      {
      required this.name,
      required this.phone,
      required this.age,
      required this.height,
      required this.weight,
      required this.blood,
      required this.gender,
      required this.socialStatus,
      required this.password});

  factory User.fromJson(Map<String, dynamic> json) => User(
      name: json["name"],
      phone: json["phone"],
      age: json["age"],
      height: json["height"],
      gender: json["gender"],
      weight: json["weight"],
      blood: json["blood"],
      socialStatus: json["socialStatus"],
      password: json["password"]);

  Map<String, dynamic> toJson() {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    var encrypted = encrypter.encrypt(password, iv: iv);
    return <String, dynamic>{
      "name": name,
      "phone": phone,
      "age": age,
      "gender": gender,
      "height": height,
      "weight": weight,
      "blood": blood,
      "socialStatus": socialStatus,
      "password": encrypted.base64
    };
  }

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final user =
        User.fromJson(snapshot.data() as Map<String, dynamic>);
    user.reference = snapshot.reference;
    return user;
  }
}
