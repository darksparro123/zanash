import 'dart:async';
import 'package:permission/permission.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zaanassh/services/geo_locator_service.dart';

class MapScreen extends StatefulWidget {
  final Position initialPostion;
  MapScreen({@required this.initialPostion});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _googleMapController = Completer();
  Future<bool> getPermisstion() async {
    print("hapoi ${GeolocationPermission.location.value}");
    return true;
  }

  @override
  void initState() {
    GeolocatorService().getCurruntLocation().listen((position) {
      centerPostion(position);
    });
    getPermisstion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.initialPostion.latitude,
                widget.initialPostion.longitude),
            zoom: 16.0,
          ),
          mapType: MapType.normal,
          myLocationEnabled: true,
          //zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _googleMapController.complete(controller);
          },
        ),
      ),
    );
  }

  Future<void> centerPostion(Position position) async {
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            zoom: 16.0, target: LatLng(position.latitude, position.longitude)),
      ),
    );
  }
}
