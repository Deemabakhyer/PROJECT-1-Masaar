// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:masaar/controllers/location_controller.dart';
import 'package:masaar/widgets/custom%20widgets/custom_search_bar.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
final locationController = Get.isRegistered<LocationController>()
    ? Get.find<LocationController>()
    : Get.put(LocationController());
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pickupController.text = locationController.pickupAddressController.text;
  }

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
                  child: Focus(
                    onKey: (node, event) {
                      if (event.logicalKey == LogicalKeyboardKey.enter) {
                        Get.toNamed('/pickup', arguments: 'Search submitted');
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: CustomSearchBar(
                      controller: pickupController,
                      leadingIcon: const Icon(Ionicons.search),
                      hintText: "Select Route",
                      onSubmitted: (value) {
                        locationController.searchAndSetLocation(value, true);
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          pickupController.clear();
                          locationController.pickupLocation.value = null;
                        },
                      ),
                      onPlaceSelected: (place) {
                        pickupController.text = place.name;

                        locationController.pickupLocation.value =
                            place.coordinates;
                        locationController.pickupAddressController.text =
                            place.name;
                        locationController.currentAddress.value = place.name;

                        Get.toNamed('/pickup');
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Get.toNamed('/Routeconfirmation');
                  },
                  child: const Icon(Ionicons.add_outline),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Focus(
                    onKey: (node, event) {
                      if (event.logicalKey == LogicalKeyboardKey.enter) {
                        Get.toNamed(
                          '/Destination',
                          arguments: 'Search submitted',
                        );
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: CustomSearchBar(
                      controller: destinationController,
                      leadingIcon: const Icon(Ionicons.search),
                      hintText: "Select Destination",
                      onSubmitted: (value) {
                        locationController.searchAndSetLocation(value, false);
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          destinationController.clear();
                          locationController.destinationLocation.value = null;
                        },
                      ),
                      onPlaceSelected: (place) {
                        locationController.destinationLocation.value =
                            place.coordinates;

                        locationController.destinationAddressController.text =
                            place.name;
                        locationController.destinationAddress.value =
                            place.name;

                        Get.toNamed('/Destination');
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {},
                  child: const Icon(Ionicons.swap_vertical),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const SizedBox(width: 8),
                Image.asset(
                  'images/mouse_pointer.png',
                  width: 23.97,
                  height: 23.97,
                ),
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
                          ? "Route"
                          : locationController.currentAddress.value,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1),
            Row(
              children: [
                const SizedBox(width: 10),
                Image.asset('images/pin.png', width: 23.97, height: 23.97),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/Destination');
                  },
                  child: Obx(
                    () => Text(
                      locationController.destinationAddress.value.isEmpty
                          ? "Destination"
                          : locationController.destinationAddress.value,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
