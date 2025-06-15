import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController {
  var currentPosition = Rxn<Position>();
  var currentAddress = ''.obs;

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Location Error", "Enable location services");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Permission Denied", "Location permission denied");
        return;
      }
    }

    final position = await Geolocator.getCurrentPosition();
    currentPosition.value = position;

    final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      currentAddress.value = "${place.name}, ${place.locality}";
    }
  }
}