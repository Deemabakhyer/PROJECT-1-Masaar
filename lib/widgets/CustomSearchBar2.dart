import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:masaar/models/place.dart';

class CustomSearchBar2 extends StatefulWidget {
  const CustomSearchBar2({
    super.key,
    required this.leadingIcon,
    required this.hintText,
    required this.trailing,
    required this.controller, // ✅ أضفناه
    required this.onPlaceSelected,
    required this.onSubmitted,
  });

  final Icon leadingIcon;
  final String hintText;
  final IconButton trailing;
  final TextEditingController controller; // ✅ أضفناه
  final Function(Place) onPlaceSelected;
  final Function(dynamic value) onSubmitted;

  @override
  State<CustomSearchBar2> createState() => _CustomSearchBar2State();
}

class _CustomSearchBar2State extends State<CustomSearchBar2> {
  final FocusNode focusNode = FocusNode();
  final SearchController searchController = SearchController();

  final List<Place> places = [
    Place(name: 'Masjid Al-Haram', coordinates: LatLng(21.4225, 39.8262)),
    Place(
      name: 'Umm al-Qura University',
      coordinates: LatLng(21.3891, 39.8579),
    ),
    Place(name: 'King Abdullah Library', coordinates: LatLng(21.4180, 39.8222)),
    Place(name: 'Hommes Burger', coordinates: LatLng(21.4135, 39.8930)),
    Place(name: 'Namaq Cafe', coordinates: LatLng(21.4192, 39.8605)),
    Place(name: 'Fitness Time Gym', coordinates: LatLng(21.4073, 39.8880)),
    Place(
      name: 'Haramain Railway Station',
      coordinates: LatLng(21.3920, 39.8495),
    ),
    Place(name: 'Broffee Cafe', coordinates: LatLng(21.4152, 39.8571)),
    Place(name: 'Makkah Mall', coordinates: LatLng(21.3890, 39.8300)),
    Place(name: 'Chirp Bakery', coordinates: LatLng(21.4101, 39.8653)),
  ];

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    focusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (context, controller) {
        return Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  focusNode.hasFocus
                      ? const Color(0xFF6A42C2)
                      : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          child: SearchBar(
            controller: widget.controller,
            focusNode: focusNode,
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            ),
            backgroundColor: const WidgetStatePropertyAll(Color(0xFFF2F2F2)),
            leading: widget.leadingIcon,
            hintText: widget.hintText,
            trailing: [SizedBox(width: 40, child: widget.trailing)],
            onTap: controller.openView,
            onChanged: (_) => controller.openView(),
            onSubmitted: (value) => controller.closeView(value),
          ),
        );
      },
      suggestionsBuilder: (context, controller) {
        final query = controller.text.toLowerCase();
        final filtered =
            places
                .where((place) => place.name.toLowerCase().contains(query))
                .toList();

        return filtered.map((place) {
          return ListTile(
            // tileColor: Colors.white,
            title: Text(place.name),
            onTap: () {
              controller.closeView(place.name);
              widget.onPlaceSelected(place); // ✅ delegate back to parent
            },
          );
        }).toList();
      },
    );
  }
}
