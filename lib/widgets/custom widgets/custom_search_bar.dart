import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    required this.leadingIcon,
    required this.hintText,
    required this.trailing, required TextEditingController controller, required Null Function(dynamic value) onSubmitted,
  });

  final Icon leadingIcon;
  final String hintText;
  final IconButton trailing;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final FocusNode focusNode = FocusNode();
  final List<String> places = [
    'Masjid Al-Haram',
    'Umm al-Qura University',
    'King Abdullah Library',
    'Hommes Burger',
    'Namaq Cafe',
    'Fitness Time Gym',
    'Haramain Railway Station',
    'Broffee Cafe',
    'Makkah Mall',
    'Chirp Bakery',
  ];

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return Container(
          height: 50,
          width: 350,
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
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            ),
            leading: widget.leadingIcon,
            hintText: widget.hintText,
            trailing: [SizedBox(width: 40, child: widget.trailing)],
            focusNode: focusNode,
            controller: controller,
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            onSubmitted: (value) {
              // ignore: avoid_print
              print('Submitted: $value');
              controller.closeView(value);
              // Optionally, perform a navigation or update UI based on the value
            },
          ),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final query = controller.text.toLowerCase();

        final List<String> filteredPlaces =
            places
                .where((place) => place.toLowerCase().contains(query))
                .toList();

        return filteredPlaces.map((place) {
          return ListTile(
            title: Text(place),
            onTap: () {
              setState(() {
                
                controller.closeView(place);
              });
            },
          );
        }).toList();
      },
    );
  }
}
