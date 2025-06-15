import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:masaar/controllers/location_controller.dart';
import 'package:masaar/widgets/custom%20widgets/custom_button.dart';
import 'package:masaar/widgets/custom%20widgets/custom_search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final locationController = Get.put(LocationController());

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Map
        FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(21.4167, 39.8167),
            initialZoom: 16,
            minZoom: 5,
            maxZoom: 18,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(21.4167, 39.8167),
                  child: const Icon(
                    Icons.location_pin,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Bottom Sheet with the Search Bar inside
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
                  // change shadow
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Your Custom Search Bar
                  SearchBar(
                    backgroundColor: const WidgetStatePropertyAll(
                      Color(0xFFF5F5F5),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    leading: Icon(Ionicons.search),
                    hintText: 'Where to?',
                    onTap: () {
                      Get.toNamed('/route');
                    },
                    trailing: [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RoutePage extends StatelessWidget {
  const RoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Your Route"),
        backgroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomSearchBar(
                    leadingIcon: Icon(Ionicons.search),
                    hintText: 'Route',
                    trailing: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        // Clear logic
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Get.toNamed('/pickup');
                  },
                  child: const Icon(Ionicons.add_outline),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomSearchBar(
                    leadingIcon: Icon(Ionicons.search),
                    hintText: 'Destination',
                    trailing: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Get.toNamed('/Destination');
                  },
                  child: const Icon(Ionicons.swap_vertical),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                SizedBox(width: 8),
                Icon(Ionicons.navigate),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    await locationController.getCurrentLocation();
                    Get.toNamed(
                      '/route',
                      arguments: {
                        'origin': locationController.currentAddress.value,
                      },
                    );
                  },
                  child: Obx(
                    () => Text(
                      locationController.currentAddress.value.isEmpty
                          ? "My Location"
                          : locationController.currentAddress.value,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
            Divider(thickness: 1),
            const Row(
              children: [
                SizedBox(width: 10),
                Icon(Ionicons.location_outline),
                SizedBox(width: 8),
                Text("Wadi Makkah Company"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Routeconfirmation extends StatelessWidget {
  const Routeconfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Map
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(21.4167, 39.8167), // Wadi Makkah
              initialZoom: 17,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(21.4167, 39.8167),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 7,
                          ),
                        ),
                        // const Icon(
                        //   Ionicons.location_outline,
                        //   size: 40,
                        //   color: Colors.purple,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          //Back Button
          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Color(0xFF6A42C2),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Bottom card
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
                    // grip indicator
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const Text(
                      "Wadi Makkah Company",
                      style: TextStyle(
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

class Destinationconfirmation extends StatelessWidget {
  const Destinationconfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(21.4167, 39.8167), // Wadi Makkah
              initialZoom: 17,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(21.4167, 39.8167),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 7,
                          ),
                        ),
                        // const Icon(
                        //   Ionicons.location_outline,
                        //   size: 40,
                        //   color: Colors.purple,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // back button
          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Color(0xFF6A42C2),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Bottom card
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
                    const Text(
                      "Wadi Makkah Company",
                      style: TextStyle(
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
                        text: "Confirm Destination",
                        isActive: true,
                        onPressed: () {
                          // putting to the next page here
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
