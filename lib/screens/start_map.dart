import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';
import 'package:zaanassh/screens/record_screen.dart';
import 'package:zaanassh/services/geo_locator_service.dart';

class StartWorkOrRun extends StatefulWidget {
  @override
  _StartWorkOrRunState createState() => _StartWorkOrRunState();
}

class _StartWorkOrRunState extends State<StartWorkOrRun> {
  GeolocatorService geolocatorService = GeolocatorService();
  double initialLatitude;
  double initialLongitude;
  Position position;
  Set<Marker> markers = {};
  Future<Position> setLocation() async {
    position = await geolocatorService.getInitialLocation();
    setState(() {
      markers.add(Marker(
          markerId: MarkerId("My Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(30.0),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(
            title: "Your Current Location",
            anchor: Offset(0.5, 0.0),
          )));
    });
    return position;
  }

  Future<bool> getPermisstion() async {
    print("hapoi ${GeolocationPermission.location.value}");

    PermissionName permissionName = PermissionName.Location;
    Permission.requestPermissions([permissionName]);

    return true;
  }

  @override
  void initState() {
    getPermisstion();
    //setLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.75,
            child: FutureBuilder<Position>(
                future: setLocation(),
                builder: (context, AsyncSnapshot<Position> snapshot) {
                  if (!snapshot.hasData) {
                    print("snapshot.hasData");
                    return Center(
                      child: SpinKitDualRing(
                        color: Colors.amber[700],
                      ),
                    );
                  }
                  // print(snapshot.data);
                  return GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    markers: markers,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          snapshot.data.latitude, snapshot.data.longitude),
                      zoom: 15,
                    ),
                  );
                }),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
                color: Color.fromRGBO(35, 36, 70, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.amber, offset: Offset(1200, 100))
                ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    print(GeolocationPermission.location.value);

                    Get.to(() => (RecordScreen(
                          showMap: true,
                          initialPosition: Position(
                            latitude: position.latitude,
                            longitude: position.longitude,
                          ),
                        )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.amber[700],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.amber[700],
                        width: 5.0,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.amber[700],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color.fromRGBO(35, 36, 70, 1),
                          width: 5.0,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.3,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.amber[700], shape: BoxShape.circle),
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.width * 0.2,
                        alignment: Alignment.center,
                        child: Text(
                          "START",
                          style: TextStyle(
                            color: Color.fromRGBO(35, 36, 70, 1),
                            letterSpacing: 1.5,
                            fontSize: MediaQuery.of(context).size.width / 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
