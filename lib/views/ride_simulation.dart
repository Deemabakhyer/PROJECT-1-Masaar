import 'dart:math';
import 'package:flutter/material.dart';
import 'package:masaar/views/my_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masaar/widgets/draggable%20scrollable%20bottom%20sheets/ride_details.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RideSimulation extends StatefulWidget {
  const RideSimulation({super.key});

  @override
  State<RideSimulation> createState() => _RideSimulationState();
}

class _RideSimulationState extends State<RideSimulation> {
  Map<String, dynamic>? _driver;
  int? driverID;
  @override
  void initState() {
    super.initState();
    fetchClosestDriver(LatLng(21.324716237626838, 39.959200490595784));//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  }

  void fetchClosestDriver(LatLng? pickupLocation) async {
    final supabase = Supabase.instance.client;

    // Step 1: Fetch drivers with lat/lng
    final response = await supabase
        .from('drivers')
        .select('driver_id, latitude, longitude');
        print(response);
    if (response.isEmpty) {
      print("No drivers found.");
      return;
    }

    // Step 2: Calculate distance and find the closest
    Map<String, dynamic>? closestDriver;
    double? minDistance;

    for (final driver in response) {
      final driverLat = driver['latitude'];
      final driverLng = driver['longitude'];

      final distance = calculateDistance(
        pickupLocation!.latitude,
        pickupLocation.longitude,
        driverLat,
        driverLng,
      );

      if (minDistance == null || distance < minDistance) {
        minDistance = distance;
        closestDriver = driver;
      }
    }

    // Step 3: Set the closest driver
    if (closestDriver != null) {
      setState(() {
        _driver = closestDriver;
        driverID = _driver!['driver_id'] as int;
        print(driverID);
      });
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371; // km
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degree) {
    return degree * pi / 180;
  }

  Future<Map<String, dynamic>?> getDriverInfo() async {
    final response =
        await Supabase.instance.client
            .from('drivers')
            .select(
              'driver_id, name, rating, phone_number, driver_image, vehicles!Driver_vehicle_id_fkey(brand, model, plate_number, color)',
            )
            .eq('driver_id', driverID as int)
            .single();
    return response;
  }

  @override
  Widget build(BuildContext context) {
    if (_driver == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Stack(
        children: [
          MyMap(
            pickupLocation: LatLng(21.324716237626838, 39.959200490595784),
            destinationLocation: LatLng(21.360190460922826, 39.90474913662535),
            driverID: driverID!,
            driverLocation: LatLng(
              _driver!['latitude'] as double,
              _driver!['longitude'] as double,
            ),
            simulateRoute: true,
          ),
          RideDetails(
            state: 'Your journey has\n started',
            driverID: driverID!,
          ),
        ],
      ),
    );
  }
}
