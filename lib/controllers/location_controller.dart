import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class LocationController extends GetxController {
  var currentPosition = Rxn<Position>();
  var currentAddress = ''.obs;
  var currentLocation = LatLng(0.0, 0.0).obs;
  var pickupLocation = Rxn<LatLng>();
  var destinationLocation = Rxn<LatLng>();
  final destinationAddress = ''.obs;

  final pickupAddressController = TextEditingController();
  final TextEditingController destinationAddressController =
      TextEditingController();
  @override
  void onInit() {
    super.onInit();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    // Request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    // Get current position
    Position position = await Geolocator.getCurrentPosition();
    currentLocation.value = LatLng(position.latitude, position.longitude);

    // Update location every few seconds (optional)
    Geolocator.getPositionStream().listen((Position pos) {
      currentLocation.value = LatLng(pos.latitude, pos.longitude);
    });
  }

  Future<void> searchAndSetLocation(String query, bool isPickup) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final result = LatLng(locations[0].latitude, locations[0].longitude);

        if (isPickup) {
          pickupLocation.value = result;
        } else {
          destinationLocation.value = result;
        }
      } else {
        Get.snackbar("Not Found", "No results for '$query'");
      }
    } catch (e) {
      Get.snackbar("Search Error", e.toString());
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Location Error", "Enable location services");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Permission Denied", "Location permission denied");
        return;
      }
    }

    final position = await Geolocator.getCurrentPosition();
    currentPosition.value = position;

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      currentAddress.value = "${place.name}, ${place.locality}";
    }
  }
}
