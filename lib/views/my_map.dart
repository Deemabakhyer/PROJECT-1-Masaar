// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:masaar/services/geolocator_service.dart';

class MyMap extends StatefulWidget {
  final LatLng? pickupLocation;
  final LatLng? destinationLocation;
  final int? driverID;
  final LatLng? driverLocation;
  final bool simulateRoute;

  const MyMap({
    super.key,
    this.pickupLocation,
    this.destinationLocation,
    this.driverLocation,
    this.simulateRoute = false,
    this.driverID,
  });

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  List<LatLng> _routePoints = [];
  int _currentIndex = 0;
  Timer? _timer;
  bool _hasStartedSecondRoute = false;

  late BitmapDescriptor carIcon;
  late BitmapDescriptor pickupIcon;
  late BitmapDescriptor destinationIcon;

  Future<void> _getCurrentLocation() async {
    Position position = await determinePosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _goToCurrentLocation() async {
    Position position = await determinePosition();
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );
  }

  Future<void> _loadCustomMarkers() async {
    pickupIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'images/pickup-pin-removebg-preview.png',
    );

    destinationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'images/destination-pin-removebg-preview.png',
    );

    carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'images/small-car.png',
    );

    setState(() {
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
    if (widget.simulateRoute) {
      await _fetchRoute('driver-pickup');
    }
  }

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

  Future<void> _fetchRoute(String routeCase) async {
    final apiKey = 'AIzaSyAZFxQXdretZtaviMcwu8nFLHyT7DI1kNg';
    String? url;
    switch (routeCase) {
      case 'driver-pickup':
        url =
            'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.driverLocation!.latitude},${widget.driverLocation!.longitude}&destination=${widget.pickupLocation!.latitude},${widget.pickupLocation!.longitude}&key=$apiKey';
        break;

      case 'pickup-destination':
        url =
            'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.pickupLocation!.latitude},${widget.pickupLocation!.longitude}&destination=${widget.destinationLocation!.latitude},${widget.destinationLocation!.longitude}&key=$apiKey';
        break;
    }

    if (url == null) return;
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      final points = _decodePolyline(
        data['routes'][0]['overview_polyline']['points'],
      );

      setState(() {
        _routePoints.clear();
        _polylines.clear();
        _routePoints = points;
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: _routePoints,
            color: const Color(0xFF6A42C2),
            width: 5,
          ),
        );
      });
      _startSimulation();
    }
  }

  void _startSimulation() {
    const duration = Duration(milliseconds: 1000);
    _currentIndex = 0;

    _timer = Timer.periodic(duration, (timer) {
      if (_currentIndex < _routePoints.length) {
        final currentPoint = _routePoints[_currentIndex];

        setState(() {
          _markers.removeWhere((m) => m.markerId.value == 'car');
          _markers.add(
            Marker(
              markerId: const MarkerId('car'),
              position: currentPoint,
              icon: carIcon,
            ),
          );

          _mapController?.animateCamera(CameraUpdate.newLatLng(currentPoint));
        });
        if (_isCloseEnough(currentPoint, widget.pickupLocation) &&
            !_hasStartedSecondRoute) {
          _hasStartedSecondRoute = true;
          timer.cancel();
          _fetchRoute('pickup-destination');
        }
        if (_isCloseEnough(currentPoint, widget.destinationLocation)) {
          timer.cancel();
          Get.toNamed('/submit_rating', arguments: widget.driverID);
        }
        _currentIndex++;
      } else {
        timer.cancel();
      }
    });
  }

  bool _isCloseEnough(LatLng? a, LatLng? b, [double threshold = 0.0003]) {
    if (a == null || b == null) return false;
    final latDiff = (a.latitude - b.latitude).abs();
    final lngDiff = (a.longitude - b.longitude).abs();
    return latDiff < threshold && lngDiff < threshold;
  }

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
    LatLng initialTarget =
        widget.driverLocation ??
        widget.pickupLocation ??
        _currentPosition ??
        const LatLng(21.324466, 39.959243); //fallback

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (controller) {
            _mapController = controller;
            Future.delayed(const Duration(milliseconds: 300), () {
              _mapController?.animateCamera(
                CameraUpdate.newLatLng(initialTarget),
              );
            });
          },
          initialCameraPosition: CameraPosition(
            target: initialTarget,
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
            shape: const CircleBorder(),
            mini: true,
            child: const Icon(Icons.my_location, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
