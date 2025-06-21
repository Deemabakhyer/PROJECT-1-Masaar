import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:masaar/controllers/location_controller.dart';
import 'package:masaar/widgets/custom%20widgets/custom_button.dart';

class Routeconfirmation extends StatefulWidget {
  const Routeconfirmation({super.key});

  @override
  State<Routeconfirmation> createState() => _RouteconfirmationState();
}

class _RouteconfirmationState extends State<Routeconfirmation> {
  final MapController _mapController = MapController();
  final locationController = Get.put(LocationController());

  LatLng? selectedPoint;
  String selectedAddress = '';
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final fromArgs = Get.arguments?['pickup'] as LatLng?;
      if (fromArgs != null) {
        selectedPoint = fromArgs;
        selectedAddress = locationController.currentAddress.value;
        _mapController.move(fromArgs, 16);
        setState(() {});
      } else {
        final pickup = locationController.pickupLocation.value;
        if (pickup != null) {
          selectedPoint = pickup;
          selectedAddress = locationController.currentAddress.value;
          _mapController.move(pickup, 16);
          setState(() {});
        }
      }
    });
  }

  Future<void> handleMapTap(LatLng point) async {
    setState(() {
      selectedPoint = point;
      selectedAddress = '';
    });

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      List<Placemark> places = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );

      if (places.isNotEmpty) {
        final place = places.first;
        final address = "${place.name}, ${place.locality}";
        setState(() {
          selectedAddress = address;
          locationController.pickupAddressController.text = address;
          locationController.currentAddress.value = address;
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Could not get location name.");
    } finally {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(21.4167, 39.8167),
              initialZoom: 16,
              onTap: (tapPosition, point) => handleMapTap(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              Obx(() {
                final pickup =
                    selectedPoint ?? locationController.pickupLocation.value;
                final destination =
                    locationController.destinationLocation.value;
                final currentLocation =
                    locationController.currentLocation.value;

                List<Marker> markers = [];
                List<Polyline> polylines = [];

                if (pickup != null) {
                  markers.add(
                    Marker(
                      point: pickup,
                      width: 60,
                      height: 60,
                      child: Image.asset(
                        "images/pickup.png",
                        width: 40,
                        height: 73,
                      ),
                    ),
                  );
                }

                if (pickup != null && destination != null) {
                  polylines.add(
                    Polyline(
                      points: [pickup, destination],
                      color: const Color(0xFF6A42C2),
                      strokeWidth: 4,
                    ),
                  );
                }

                markers.add(
                  Marker(
                    point: currentLocation,
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.rotate(
                          angle: 0,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment.topCenter,
                                radius: 1.0,
                                colors: [
                                  Color.fromARGB(100, 33, 150, 243),
                                  Colors.transparent,
                                ],
                                stops: [0.2, 1.0],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                return Stack(
                  children: [
                    if (polylines.isNotEmpty)
                      PolylineLayer(polylines: polylines),
                    MarkerLayer(markers: markers),
                    // LOCATION BUTTON
                    Positioned(
                      bottom: 200,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          _mapController.move(currentLocation, 16);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),

          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: const Color(0xFF6A42C2),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Text(
                      selectedAddress.isEmpty ? " " : selectedAddress,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.33,
                      ),
                    ),

                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: CustomButton(
                        text: "Confirm Pickup",
                        isActive: true,
                        onPressed: () {
                          Get.toNamed('/route');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
