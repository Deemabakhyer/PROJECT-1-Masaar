import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:masaar/controllers/location_controller.dart';
import 'package:masaar/widgets/custom%20widgets/custom_button.dart';
import 'package:masaar/widgets/custom%20widgets/custom_car_option2.dart';

class PackageTypesPage extends StatefulWidget {
  const PackageTypesPage({super.key});

  @override
  State<PackageTypesPage> createState() => _PackageTypesPageState();
}

class _PackageTypesPageState extends State<PackageTypesPage> {
  final MapController _mapController = MapController();
  final locationController = Get.put(LocationController());
  final selectedCarOption = ValueNotifier<String?>(null);

  final List<String> items = ['Cash', 'Apple Pay', 'Credit/Debit Card'];
  final valueListenable = ValueNotifier<String?>(null);
  LatLng? selectedPoint;
  String selectedAddress = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final destination = locationController.destinationLocation.value;
      if (destination != null) {
        _mapController.move(destination, 16);
        setState(() {
          selectedPoint = destination; 
          selectedAddress = locationController.destinationAddress.value;
        });
      }
    }); 
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
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              Obx(() {
                final pickup = locationController.pickupLocation.value;
                final destination =
                    locationController.destinationLocation.value;
                final current = locationController.currentLocation.value;

                List<Marker> markers = [];
                List<Polyline> polylines = [];

                if (pickup != null) {
                  markers.add(
                    Marker(
                      point: pickup,
                      width: 40,
                      height: 40,
                      child: Image.asset('images/pickup.png'),
                    ),
                  );
                }

                if (destination != null) {
                  markers.add(
                    Marker(
                      point: destination,
                      width: 40,
                      height: 40,
                      child: Image.asset('images/des.png'),
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
                    point: current,
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
                      top: 400,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          _mapController.move(current, 16);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
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
         
          // Bottom Sheet
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
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

                    ValueListenableBuilder<String?>(
                      valueListenable: selectedCarOption,
                      builder: (context, selected, _) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () => selectedCarOption.value = 'Saver',
                              child: CustomCarOption2(
                                carOption: 'Saver',
                                price: '35',
                                arrivalTime: '9 min',
                                carImg: 'images/saver-car.png',
                                capacity: '4',
                                isSelected: selected == 'Saver',
                              ),
                            ),
                            GestureDetector(
                              onTap: () => selectedCarOption.value = 'Comfort',
                              child: CustomCarOption2(
                                carOption: 'Comfort',
                                price: '48',
                                arrivalTime: '12 min',
                                carImg: 'images/comfort-car.png',
                                capacity: '4',
                                isSelected: selected == 'Comfort',
                              ),
                            ),
                            GestureDetector(
                              onTap: () => selectedCarOption.value = 'Family',
                              child: CustomCarOption2(
                                carOption: 'Family',
                                price: '86',
                                arrivalTime: '12 min',
                                carImg: 'images/family-car.png',
                                capacity: '7',
                                isSelected: selected == 'Family',
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                   
                    const SizedBox(height: 8),
                  ],
                ),
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

                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: CustomButton(
                        text: "Select",
                        isActive: true,
                        onPressed: () {
                          Get.toNamed('/payment');
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
