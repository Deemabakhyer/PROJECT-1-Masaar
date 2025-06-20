import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaar/widgets/popups/cancel_ride_popup.dart';

class CancelRideAvatar extends StatelessWidget {
  const CancelRideAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.dialog(CancelRidePopup());
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFFF2F2F2),
            radius: 30,
            child: Image.asset(
              'images/cancel-ride.png',
              width: 30,
              height: 30,
              color: Color(0xFF6A42C2),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Cancel ride",
            style: TextStyle(fontSize: 16, color: Color(0xFF919191)),
          ),
        ],
      ),
    );
  }
}
