import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:masaar/controllers/location_controller.dart';
import 'package:masaar/widgets/custom_button.dart';

class PaymentTypePage extends StatefulWidget {
  const PaymentTypePage({super.key});

  @override
  State<PaymentTypePage> createState() => _PaymentTypePageState();
}

class _PaymentTypePageState extends State<PaymentTypePage> {
  final MapController _mapController = MapController();
  final locationController = Get.find<LocationController>();

  String selectedMethod = 'Cash';
  int walletBalance = 0;
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
                      child: Image.asset(
                        'images/pickup.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  );
                }

                if (destination != null) {
                  markers.add(
                    Marker(
                      point: destination,
                      width: 40,
                      height: 40,
                      child: Image.asset(
                        'images/des.png',
                        width: 40,
                        height: 40,
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
                      top: 280,
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
          Positioned(
            bottom: 135,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const Text(
                      "Payment",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 12),

                    walletBalanceCard(
                      balance: walletBalance,
                      selectedMethod: selectedMethod,
                      onTap:
                          () =>
                              setState(() => selectedMethod = "Wallet balance"),
                      context: context,
                    ),

                    const SizedBox(height: 16),
                    const Divider(thickness: 1),
                    const SizedBox(height: 16),

                    const Text(
                      "Payment methods",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _paymentOption(
                      "Apple Pay",
                      Image.asset('images/applePay.png', width: 56, height: 41),
                      selectedMethod == "Apple Pay",
                      () => setState(() => selectedMethod = "Apple Pay"),
                    ),
                    _paymentOption(
                      "Cash",
                      Image.asset('images/cash.png', width: 56, height: 41),
                      selectedMethod == "Cash",
                      () => setState(() => selectedMethod = "Cash"),
                    ),
                    _paymentOption(
                      "credit card",
                      Image.asset(
                        'images/creditCard.png',
                        width: 64,
                        height: 64,
                      ),
                      selectedMethod == "Card",
                      () => setState(() => selectedMethod = "Card"),
                    ),
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
                          Get.toNamed('/Actcard');
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

  Widget _paymentOption(
    String label,
    Widget leadingIcon,
    bool isSelected,
    VoidCallback onTap, {
    bool isAdd = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: leadingIcon,
      title: Text(label, style: const TextStyle(fontSize: 15)),
      trailing:
          isAdd
              ? const Icon(Icons.add, color: Colors.grey)
              : isSelected
              ? const Icon(Icons.check_circle, color: Colors.deepPurple)
              : const Icon(Icons.circle_outlined, color: Colors.grey),
    );
  }
}

Widget walletBalanceCard({
  required BuildContext context, // 👈 Add this
  required int balance,
  required String selectedMethod,
  required VoidCallback onTap,
}) {
  final isSelectable = balance > 0;
  final isSelected = selectedMethod == "Wallet balance" && isSelectable;

  return GestureDetector(
    onTap: () {
      if (isSelectable) {
        onTap();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wallet selected ✅"),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.deepPurple,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "You don't have enough balance to use the wallet.",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.white,
          ),
        );
      }
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE2D9F3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Wallet balance",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF563B9C),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.asset(
                    'images/saudiriyalsymbol.png',
                    width: 32,
                    height: 32,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "$balance",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A42C2),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          isSelected
              ? const Icon(Icons.check_circle, color: Color(0xFF6A42C2))
              : const Icon(Icons.circle_outlined, color: Colors.grey),
        ],
      ),
    ),
  );
}
