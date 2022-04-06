import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:flutter/cupertino.dart';

class MapCard extends StatelessWidget {
   MapCard({Key? key}) : super(key: key);

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.787741144127505, 46.30174386769324),
    zoom: 3,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(24.787741144127505, 46.30174386769324),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

   // Future<void> checkPermission() async {
   //   Location location = new Location();
   //
   //   bool _serviceEnabled;
   //   PermissionStatus _permissionGranted;
   //
   //   _serviceEnabled = await location.serviceEnabled();
   //   if (!_serviceEnabled) {
   //     _serviceEnabled = await location.requestService();
   //     if (!_serviceEnabled) {
   //       return;
   //     }
   //   }
   //
   //   _permissionGranted = await location.hasPermission();
   //   if (_permissionGranted == PermissionStatus.denied) {
   //     _permissionGranted = await location.requestPermission();
   //     if (_permissionGranted != PermissionStatus.granted) {
   //       return;
   //     }
   //   }
   //
   //   // _locationData = await location.getLocation();
   //   location.getLocation().then((value) {
   //     setState(() {
   //       _locationData = value;
   //       // _kGooglePlex.target=_locationData;
   //     });
   //   });
   // }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.hybrid,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      gestureRecognizers: Set()
        ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
        ..add(Factory<ScaleGestureRecognizer>(
                () => ScaleGestureRecognizer()))
        ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
        ..add(Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer())),

      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      onTap: (value){
        print(value);
      },
    );
  }
}
