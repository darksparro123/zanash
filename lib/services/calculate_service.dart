import 'package:geolocator/geolocator.dart';
import 'package:zaanassh/services/geo_locator_service.dart';

class CalculateService {
  GeolocatorService geolocatorService = GeolocatorService();
  Geolocator geolocator = Geolocator();
//calculate distance
  Stream<double> calculateDistance(Position origin) async* {
    double curruntLat, currentLon, distance;
    geolocatorService.getCurruntLocation().listen((event) async {
      curruntLat = event.latitude;
      currentLon = event.longitude;
      distance = await geolocator.distanceBetween(
          origin.latitude, origin.longitude, 6.5825612, 8.54);
    });

    yield distance;
  }
}
