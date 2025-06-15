import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:masaar/services/geolocator_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Map extends StatefulWidget {
  final LatLng? pickupLocation;
  final LatLng? destinationLocation;
  final LatLng? driverLocation;


  const Map({super.key, this.pickupLocation, this.destinationLocation, this.driverLocation});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  List<LatLng> _routePoints = [];
  int _currentIndex = 0;
  Timer? _timer;

  late BitmapDescriptor carIcon;
  late BitmapDescriptor pickupIcon;
  late BitmapDescriptor destinationIcon;

  Future<void> _getCurrentLocation() async {
    Position position = await determinePosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      // Move camera to current location
      _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
    });
  }

  Future<void> _goToCurrentLocation() async {
    Position position = await determinePosition();
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );
  }

  Future<void> _fetchRoute() async {
    final apiKey = 'AIzaSyAZFxQXdretZtaviMcwu8nFLHyT7DI1kNg';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.pickupLocation!.latitude},${widget.pickupLocation!.longitude}&destination=${widget.destinationLocation!.latitude},${widget.destinationLocation!.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      final points = _decodePolyline(
        data['routes'][0]['overview_polyline']['points'],
      );

      setState(() {
        _routePoints = points;
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            points: _routePoints,
            color: Color(0xFF6A42C2),
            width: 5,
          ),
        );
      });

      _startSimulation();
    }
  }

  void _startSimulation() {
    const duration = Duration(milliseconds: 500);
    _timer = Timer.periodic(duration, (timer) {
      if (_currentIndex < _routePoints.length) {
        setState(() {
          // Update car marker position
          _markers.removeWhere((m) => m.markerId.value == 'car');
          _markers.add(
            Marker(
              markerId: const MarkerId('car'),
              position: _routePoints[_currentIndex],
              icon: carIcon,
              // BitmapDescriptor.defaultMarkerWithHue(
              //   BitmapDescriptor.hueBlue,
              // ),
            ),
          );
          // Move camera to car position
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(_routePoints[_currentIndex]),
          );
        });

        _currentIndex++;
      } else {
        timer.cancel();
      }
    });
  }

  // Polyline decoder
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  Future<void> _loadCustomMarkers() async {
    // Load custom pickup icon
    // ignore: deprecated_member_use
    pickupIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'images/pickup-pin-removebg-preview.png',
    );

    // Load custom destination icon
    // ignore: deprecated_member_use
    destinationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'images/destination-pin-removebg-preview.png',
    );

    // ignore: deprecated_member_use
    carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'images/small-car.png',
    );

    setState(() {
      // Add pickup & destination markers
      if (widget.pickupLocation != null) {
        _markers.add(
          Marker(
            markerId: const MarkerId('pickup'),
            position: widget.pickupLocation!,
            icon: pickupIcon,
            infoWindow: const InfoWindow(title: 'Pickup'),
          ),
        );
      }

      if (widget.destinationLocation != null) {
        _markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: widget.destinationLocation!,
            icon: destinationIcon,
            infoWindow: const InfoWindow(title: 'Destination'),
          ),
        );
      }
    });

    if (widget.pickupLocation != null && widget.destinationLocation != null) {
      await _fetchRoute();
    }
  }

  // void _navigatePages(){
  //   if(widget.driverLocation == widget.pickupLocation){
  //     Navigator.push(context)

  //   }
  // }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _getCurrentLocation();
      await _loadCustomMarkers();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (controller) {
            _mapController = controller;
            Future.delayed(Duration(milliseconds: 300), () {
              if (_currentPosition != null) {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLng(_currentPosition!),
                );
              }
            });
          },
          initialCameraPosition: CameraPosition(
            target:
                _currentPosition ??
                const LatLng(21.324466, 39.959243), // Fallback
            zoom: 14,
          ),
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          markers: _markers,
          polylines: _polylines,
        ),

        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.30 + 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _goToCurrentLocation,
            backgroundColor: Colors.white,
            shape: CircleBorder(),
            mini: true,
            child: const Icon(Icons.my_location, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
