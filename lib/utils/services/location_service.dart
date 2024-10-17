import 'package:location/location.dart';

const GOOGLE_API_KEY = 'AIzaSyB42AxvrirgNtGarL2Y84D4cw0eEhBkzXk';

class LocationService {
  static Future<LocationData> getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw 'Location service is not enabled, or device does not have this service';
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw 'Location permission not granted';
      }
    }

    locationData = await location.getLocation();
    return locationData;
  }

  static String buildLocationImagePath(
      {required double lat, required double long}) {
    // best practice is to add "&signature=YOUR_SIGNATURE" at the end of the URL of a Maps Static API image <<https://developers.google.com/maps/documentation/maps-static/digital-signature>>
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=$GOOGLE_API_KEY';
  }
}
