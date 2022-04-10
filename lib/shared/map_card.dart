import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:for_you_flutter/constants/constant_images.dart';
import 'package:for_you_flutter/data/providers/hospitals_manager.dart';
import 'package:for_you_flutter/shared/components.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class MapCard extends StatefulWidget {
  const MapCard({Key? key, this.onTapMap, required this.initialPosition})
      : super(key: key);
  final LatLng initialPosition;
  final ArgumentCallback<LatLng>? onTapMap;

  @override
  State<MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  List<Marker> markers = [];
  late Completer<GoogleMapController> _controller;
Location x=Location();

  late CameraPosition initialCameraPosition;

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
  //   location.getLocation().then((value) {});
  // }

  _handleTap(LatLng point) {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId("1"),
        position: point,
        infoWindow: InfoWindow(
          title: 'hospital-location'.tr(),
        ),
      ));
      widget.onTapMap!(point);
    });
  }

  @override
  void initState() {
    _controller = Completer();
    initialCameraPosition = CameraPosition(
      target: widget.initialPosition,
      zoom: 15,
    );
    _handleTap(widget.initialPosition);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: Set<Marker>.of(markers),
      mapType: MapType.normal,
      zoomControlsEnabled: true,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      gestureRecognizers: Set()
        ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
        ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
        ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
        ..add(Factory<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer())),
      initialCameraPosition: initialCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      onTap: _handleTap,
    );
  }
}
