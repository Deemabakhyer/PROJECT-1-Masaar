import 'package:flutter/material.dart';

class SettingsHeader extends StatelessWidget {
  final String title;

  const SettingsHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
        ),
      ),
    );
  }
}
