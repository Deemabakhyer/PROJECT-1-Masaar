import 'package:flutter/material.dart';
import 'package:masaar/views/map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masaar/widgets/draggable%20scrollable%20bottom%20sheets/driver_info_sheet.dart';

class HeadingToDestination extends StatelessWidget {
  const HeadingToDestination({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Map(
            pickupLocation: LatLng(21.324716237626838, 39.959200490595784),
            destinationLocation: LatLng(21.424476438147202, 39.82544014904654),
          ),
          DriverInfo(state: 'Heading to Destination')
        ],
      ),
    );
  }
}
