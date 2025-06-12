import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    required this.leadingIcon,
    required this.hintText,
    required this.trailing,
  });

  final Icon leadingIcon;
  final String hintText;
  final IconButton trailing;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
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

  final FocusNode focusNode = FocusNode();
  final List places = [
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
          ),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final query = controller.text.toLowerCase();

        final List filteredPlaces =
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

// How to use:
//  CustomSearchBar(
//             leadingIcon: Icon(Icons.search),
//             hintText: 'text here',
//             trailing: IconButton(onPressed: () {}, icon: Icon(Icons.clear)),
//           ),
