import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:masaar/controllers/location_controller.dart';

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
maxZoom: 19,    
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
                // Marker(
                //   point: LatLng(21.4167, 39.8167),
                //   child: const Icon(
                //     Icons.location_pin,
                //     size: 50,
                //     color: Colors.red,
                //   ),
                // ),
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

                  //Custom Search Bar
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
