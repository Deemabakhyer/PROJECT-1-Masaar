import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:masaar/widgets/custom_button.dart';
import 'package:masaar/widgets/custom_car_option.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class PackageTypesPage extends StatelessWidget {
  PackageTypesPage({super.key});

  final List<String> items = ['Cash', 'Apple Pay', 'Credit/Debit Card'];
  final valueListenable = ValueNotifier<String?>(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(21.4167, 39.8167),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              // الخط
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [
                      LatLng(21.4225, 39.8262),
                      LatLng(21.4167, 39.8167),
                    ],
                    color: Colors.purple,
                    strokeWidth: 4,
                  ),
                ],
              ),
              // icon of arriave
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(21.4167, 39.8167),
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.purple,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              width: 350,
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(7),
                boxShadow: const [
                  // BoxShadow(
                  //   color: Colors.black26,
                  //   blurRadius: 4,
                  //   offset: Offset(0, 2),
                  // ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Pick-up location",
                      style: TextStyle(color: Color(0xFF919191)),
                    ),
                  ),
                  Icon(Ionicons.add_outline),
                ],
              ),
            ),
          ),

          // Bottom Sheet
          Positioned(
            bottom: 0,
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
                    const CustomCarOption(
                      carOption: 'Saver',
                      price: '35',
                      arrivalTime: '9 min',
                      carImg: 'images/saver-car.png',
                      capacity: '4',
                    ),
                    const CustomCarOption(
                      carOption: 'Comfort',
                      price: '48',
                      arrivalTime: '12 min',
                      carImg: 'images/comfort-car.png',
                      capacity: '4',
                    ),
                    const CustomCarOption(
                      carOption: 'Family',
                      price: '86',
                      arrivalTime: '12 min',
                      carImg: 'images/family-car.png',
                      capacity: '7',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 8),
                        ValueListenableBuilder<String?>(
                          valueListenable: valueListenable,
                          builder: (context, selectedValue, _) {
                            return DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Row(
                                  children: [
                                    Image.asset(
                                      'images/cash.png',
                                      width: 56, // adjust size
                                      height: 41,
                                    ),
                                    const SizedBox(
                                      width: 9.44,
                                    ), // space between icon and text
                                    const Text(
                                      'Cash',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),

                                items:
                                    items
                                        .map(
                                          (String item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                        )
                                        .toList(),
                                value: selectedValue,
                                onChanged: (String? value) {
                                  valueListenable.value = value;
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  height: 40,
                                  width: 190,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    CustomButton(
                      text: 'Select',
                      isActive: true,
                      onPressed: () {
                        Get.toNamed('/payment');
                      },
                    ),

                    // زبطي الخطوط
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
