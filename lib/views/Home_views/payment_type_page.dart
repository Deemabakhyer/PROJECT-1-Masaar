import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:latlong2/latlong.dart';

class PaymentTypePage extends StatefulWidget {
  const PaymentTypePage({super.key});

  @override
  State<PaymentTypePage> createState() => _PaymentTypePageState();
}

class _PaymentTypePageState extends State<PaymentTypePage> {
  String selectedMethod = 'Cash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Background
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
            ],
          ),

          // Pick-up location search bar
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

                  Container(
                    width: 371,
                    height: 124,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(
                        106,
                        66,
                        194,
                        0.25,
                      ), // same as 25% opacity
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Wallet balance",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF563B9C),
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              "50",
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w600,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Image.asset(
                              'images/saudiriyalsymbol.png',
                              width: 37,
                              height: 41,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(thickness: 1),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      "+ Add money",
                      style: TextStyle(
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 24),
                    onTap: () {},
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Payment methods",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),

                  _paymentOption(
                    "Apple Pay",
                    Image.asset('images/applePay.png', width: 56, height: 41),
                    selectedMethod == "Apple Pay",
                    () {
                      setState(() => selectedMethod = "Apple Pay");
                    },
                  ),
                  _paymentOption(
                    "Cash",
                    Image.asset('images/cash.png', width: 56, height: 41),
                    selectedMethod == "Cash",
                    () {
                      setState(() => selectedMethod = "Cash");
                    },
                  ),
                  _paymentOption(
                    "Add credit/debit card",
                    Image.asset('images/creditCard.png', width: 64, height: 64),
                    selectedMethod == "Card",
                    () {
                      setState(() => selectedMethod = "Card");
                      Get.toNamed('/card');
                    },
                    isAdd: true,
                  ),
                ],
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
