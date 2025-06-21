import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final Image image;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const SettingsItem({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Image(image: image.image),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        const Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: Color(0xFFE0E0E0),
        ),
      ],
    );
  }
}
