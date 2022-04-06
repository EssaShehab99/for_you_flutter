import 'package:google_maps_flutter/google_maps_flutter.dart';

class Hospital {
  int id;
  String? docID;
  String name;
  LatLng? location;
  bool isChecked;
  Hospital({required this.id, this.docID, this.location,  required this.name,  required this.isChecked});
}
