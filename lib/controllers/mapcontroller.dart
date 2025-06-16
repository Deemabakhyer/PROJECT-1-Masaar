import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../services/geolocator_service.dart';

class MapController extends GetxController {
  final Rxn<LatLng> currentPosition = Rxn<LatLng>();
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  late BitmapDescriptor carIcon;
  late BitmapDescriptor pickupIcon;
  late BitmapDescriptor destinationIcon;

  List<LatLng> routePoints = [];

  LatLng? pickupLocation;
  LatLng? destinationLocation;

  void setLocations({LatLng? pickup, LatLng? destination}) {
    pickupLocation = pickup;
    destinationLocation = destination;
  }

  Future<void> getCurrentLocation() async {
    Position position = await determinePosition();
    currentPosition.value = LatLng(position.latitude, position.longitude);
  }

  Future<void> fetchRoute() async {
    final apiKey = 'YOUR_GOOGLE_API_KEY';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${pickupLocation!.latitude},${pickupLocation!.longitude}&destination=${destinationLocation!.latitude},${destinationLocation!.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      final points = _decodePolyline(
        data['routes'][0]['overview_polyline']['points'],
      );
      routePoints = points;
      polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: routePoints,
          color: Color(0xFF6A42C2),
          width: 5,
        ),
      );
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  Future<void> loadCustomMarkers() async {
    pickupIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'images/pickup-pin-removebg-preview.png',
    );

    destinationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'images/destination-pin-removebg-preview.png',
    );

    if (pickupLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickupLocation!,
          icon: pickupIcon,
          infoWindow: const InfoWindow(title: 'Pickup'),
        ),
      );
    }

    if (destinationLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: destinationLocation!,
          icon: destinationIcon,
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
      );
    }

    if (pickupLocation != null && destinationLocation != null) {
      await fetchRoute();
    }
  }
}
