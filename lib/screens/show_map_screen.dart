import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:zaanassh/screens/map_screen.dart';
import 'package:zaanassh/services/geo_locator_service.dart';

class ShowMapScreen extends StatefulWidget {
  @override
  _ShowMapScreenState createState() => _ShowMapScreenState();
}

class _ShowMapScreenState extends State<ShowMapScreen> {
  GeolocatorService geolocatonService = GeolocatorService();
  @override
  Widget build(BuildContext context) {
    return /*StreamBuilder<Position>(
                stream: geolocatonService.getCurruntLocation(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  return Text(
                      "Lat : ${snapshot.data.latitude} Lng: ${snapshot.data.longitude}",
                      style: TextStyle(color: Colors.white));
                }),
             child:*/
        FutureProvider(
            create: (context) => geolocatonService.getInitialLocation(),
            child: Consumer<Position>(
              builder: (context, position, widget) {
                if (position == null)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                return MapScreen(
                  initialPostion: position,
                );
              },
            ));
  }
}
