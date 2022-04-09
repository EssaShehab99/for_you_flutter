import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:for_you_flutter/constants/constant_values.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Hospital {
  int id;
  String? name;
  LatLng? location;
  bool isChecked;

  Hospital(
      {required this.id,
      this.location,
       this.name,
      required this.isChecked});

  factory Hospital.fromJson(Map<String, dynamic> json, String id) {
    GeoPoint? geoPoint = json["location"];
    return Hospital(
      id: ConstantValues.hospitalsList.firstWhere((element) => element.id==int.parse(id)).id,
      location: geoPoint != null
          ? LatLng(geoPoint.latitude, geoPoint.longitude)
          : null,
      isChecked: true,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "location": location != null
          ? GeoPoint(location!.latitude, location!.longitude)
          : null,
    };
  }
}
