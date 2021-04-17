import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:zaanassh/services/geo_locator_service.dart';

class MapPage extends StatefulWidget {
  final double originLat, originLon, destinLat, destinLon;
  MapPage(
      {@required this.originLat,
      @required this.originLon,
      @required this.destinLat,
      @required this.destinLon});
  @override
  _MapPageState createState() => _MapPageState();
}

// Starting point latitude
/*double _originLatitude = 81.03573313847882;
// Starting point longitude
double _originLongitude = 81.03573313847882;
// Destination latitude
double _destLatitude = 6.911111669975161;
// Destination Longitude
double _destLongitude = 81.06036654446233;*/
// Markers to show points on the map
Map<MarkerId, Marker> markers = {};

PolylinePoints polylinePoints = PolylinePoints();
Map<PolylineId, Polyline> polylines = {};

class _MapPageState extends State<MapPage> {
  double originLatitude;
  double originLongitude;
  double destLatitude;
  double destLongitude;
  GeolocatorService geolocatorService = GeolocatorService();

  //set Initial posotion
  void setIntilaServic() {
    try {
      setState(() {
        originLatitude = widget.originLat;
        originLongitude = widget.originLon;
        destLatitude = widget.destinLat;
        destLongitude = widget.destinLon;
        _kGooglePlex = CameraPosition(
          target: LatLng(
            widget.originLat,
            widget.originLon,
          ),
          zoom: 14,
        );
      });
    } catch (e) {
      print("get location failed $e");
    }
  }

  // Google Maps controller
  Completer<GoogleMapController> _controller = Completer();
  // Configure map position and zoom
  CameraPosition _kGooglePlex;

  @override
  void initState() {
    setIntilaServic();
    Future.delayed(Duration(seconds: 4)).then((value) {
      /// add origin marker origin marker
      _addMarker(
        LatLng(originLatitude, originLongitude),
        "origin",
        BitmapDescriptor.defaultMarker,
      );

      // Add destination marker
      _addMarker(
        LatLng(destLatitude, destLongitude),
        "destination",
        BitmapDescriptor.defaultMarkerWithHue(90),
      );

      _getPolyline();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (originLatitude == null || _kGooglePlex == null)
          ? Center(
              child: SpinKitCircle(
                color: Colors.orange[600],
              ),
            )
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              tiltGesturesEnabled: true,
              //compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              polylines: Set<Polyline>.of(polylines.values),
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                setIntilaServic();
              },
            ),
    );
  }

  // This method will add markers to the map based on the LatLng position
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 8,
      color: Colors.orange[700],
      endCap: Cap.roundCap,
      startCap: Cap.roundCap,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBInYMrODKeADbONhwaJ6-SqawifKDnzew",
      PointLatLng(originLatitude, originLongitude),
      PointLatLng(destLatitude, destLongitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(
          point.latitude,
          point.longitude,
        ));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }
}
