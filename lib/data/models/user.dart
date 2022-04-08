import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String name;
  String phone;
  int age;
  double height;
  double weight;
  String blood;
  String socialStatus;
  String password;
  DocumentReference? reference;

  final key = encrypt.Key.fromUtf8('my 32 length key................');
  final iv = encrypt.IV.fromLength(16);

  // var decrypted = encrypter.decrypt(encrypted, iv: iv);

  User(
      {this.id,
      required this.name,
      required this.phone,
      required this.age,
      required this.height,
      required this.weight,
      required this.blood,
      required this.socialStatus,
      required this.password});

  factory User.fromJson(Map<String, dynamic> json, String id) => User(
      name: json["name"],
      phone: json["phone"],
      age: json["age"],
      height: json["height"],
      weight: json["weight"],
      blood: json["blood"],
      socialStatus: json["socialStatus"],
      password: json["password"]);

  Map<String, dynamic> toJson() {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    var encrypted = encrypter.encrypt(password, iv: iv);
    return <String, dynamic>{
      "id": id,
      "name": name,
      "phone": phone,
      "age": age,
      "height": height,
      "weight": weight,
      "blood": blood,
      "socialStatus": socialStatus,
      "password": encrypted.base64
    };
  }

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final user =
        User.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.id);
    user.reference = snapshot.reference;
    return user;
  }
}
