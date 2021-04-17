import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  final Geolocator geo = Geolocator();

  Stream<Position> getCurruntLocation() {
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

    return geo.getPositionStream(locationOptions);
  }

  Future<Position> getInitialLocation() async {
    return geo.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
