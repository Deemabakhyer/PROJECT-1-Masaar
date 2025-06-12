import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:masaar/widgets/draggable%20scrollable%20bottom%20sheets/draggable_bottom_sheet.dart';
// import 'package:masaar/widgets/draggable_bottom_sheet.dart';

class AssigningDriver extends StatefulWidget {
  const AssigningDriver({super.key});

  @override
  State<AssigningDriver> createState() => _AssigningDriverState();
}

class _AssigningDriverState extends State<AssigningDriver> {
  Future<LatLng> getCurrentLocation() async {
    try {
      // First, check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }

      // Check and request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied");
      }

      // If permissions are granted, get the position
      Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint("Error getting location: $e");
      return LatLng(0, 0); // fallback location
    }
  }

  LatLng? _currentPosition;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                options: MapOptions(
                  initialCenter: _currentPosition!,
                  initialZoom: 14,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: "com.example.masaar",
                  ),
                  CurrentLocationLayer(),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentPosition!,
                        child: Image.asset(
                          'images/pickup_pin.png',
                          cacheHeight: 94,
                          cacheWidth: 96,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          DraggableBottomSheet(),
        ],
      ),
    );
  }
}
