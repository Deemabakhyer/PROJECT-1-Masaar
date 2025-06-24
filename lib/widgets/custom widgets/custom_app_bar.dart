import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String? driverName;

  const CustomAppBar({super.key, required this.driverName})
    : preferredSize = const Size.fromHeight(120.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      decoration: const BoxDecoration(
        color: Color(0xFF6A42C2), // Purple color
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.only(
        top: 40,
        left: 16,
        right: 16,
      ), // top padding for safe area
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          // Name and avatar
          Row(
            children: [
               Text(
                driverName!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                backgroundColor: Color(0xFFB2C7FF),
                child: Text(
                  "H",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
