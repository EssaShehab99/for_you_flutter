import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Hospital {
  int id;
  String name;
  LatLng? location;
  bool isChecked;
  Hospital({required this.id, this.location,  required this.name,  required this.isChecked});

  factory Hospital.fromJson(Map<String, dynamic> json, String id) =>
      Hospital(
        id: int.parse(id),
        name: json["name"],
        location: json["location"],
        isChecked: true,
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "name": name,
      "location": location!=null?GeoPoint(location!.latitude, location!.longitude):null,
    };
  }

}
