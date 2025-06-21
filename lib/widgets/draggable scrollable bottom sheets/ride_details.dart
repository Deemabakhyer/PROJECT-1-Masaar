import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaar/widgets/custom%20widgets/cancel_ride_avatar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RideDetails extends StatefulWidget {
  const RideDetails({super.key, required this.state, required this.driverID});

  final String state;
  final int driverID;
  // final String pickupLocation;
  // final String destinationLocation;

  @override
  State<RideDetails> createState() => _RideDetailsState();
}

class _RideDetailsState extends State<RideDetails> {
  final user = Supabase.instance.client.auth.currentUser;
  late final int customerID;
  Map<String, dynamic>? _driver;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    customerID = int.tryParse(user?.id ?? '0') ?? 0;
    fetchDriverInfo();
  }

  Future<void> fetchDriverInfo() async {
    final response =
        await Supabase.instance.client
            .from('drivers')
            .select('''
          driver_id,
          name,
          rating,
          phone_number,
          driver_image,
          vehicles!Driver_vehicle_id_fkey(
            brand,
            model,
            plate_number,
            color
          )
        ''')
            .eq('driver_id', widget.driverID)
            .single();

    setState(() {
      _driver = response;
      _loading = false;
    });
  }

  Future<void> saveRide({
    required int driverID,
    required int customerID,
    required String pickup,
    required String destination,
  }) async {
    try {
      await Supabase.instance.client.from('rides').insert({
        'driver_id': driverID,
        'customer_id': customerID,
        'pickup': pickup,
        'destination': destination,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save ride: $e')));
      }
    }
  }

  @override
  void dispose() {
    saveRide(
      driverID: widget.driverID,
      customerID: customerID,
      pickup: 'Wadi Makkah Company',
      destination: 'Masjid Al-Haram',
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_driver == null) {
      return const Center(child: Text("Driver not found"));
    }

    final vehicle = _driver!['vehicles'];

    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Top section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.state,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Image.asset(
                      'images/comfort-car.png',
                      width: 80,
                      height: 80,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Car and driver info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFADC8F5),
                      backgroundImage:
                          _driver!['driver_image'] != null
                              ? NetworkImage(_driver!['driver_image'])
                              : null,
                      child:
                          _driver!['driver_image'] == null
                              ? Text(
                                _driver!['name'][0],
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              )
                              : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${vehicle['color']} ${vehicle['brand']} ${vehicle['model']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF919191),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vehicle['plate_number'] ?? 'Unknown plate',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF69696B),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                _driver!['name'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF919191),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber,
                              ),
                              Text(
                                (_driver!['rating'] as num?)?.toStringAsFixed(
                                      1,
                                    ) ??
                                    '0.0',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed:
                          () => launchUrlString(
                            "tel://${_driver!['phone_number']}",
                          ),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(Icons.call, color: Color(0xFF6A42C2)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/my_chat');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(
                        Icons.message,
                        color: Color(0xFF6A42C2),
                      ),
                    ),
                  ],
                ),

                // Rest of your UI continues...
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'My route',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const ListTile(
                  leading: Icon(Icons.location_on, color: Color(0xFF6A42C2)),
                  title: Text(
                    'Wadi Makkah Company',
                    style: TextStyle(fontSize: 20, color: Color(0xFF69696B)),
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.add, color: Color(0xFF6A42C2)),
                  title: Text(
                    'Add stop',
                    style: TextStyle(fontSize: 20, color: Color(0xFF919191)),
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.place, color: Color(0xFF6A42C2)),
                  title: Text(
                    'Masjid Al-Haram',
                    style: TextStyle(fontSize: 20, color: Color(0xFF69696B)),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Edit destinations',
                      style: TextStyle(color: Color(0xFF6A42C2)),
                    ),
                  ),
                ),
                const Divider(),
                const Text(
                  'Payment method',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset('images/cash.png', width: 56, height: 41),
                    const SizedBox(width: 8),
                    const Text(
                      'cash',
                      style: TextStyle(fontSize: 20, color: Color(0xFF69696B)),
                    ),
                    const Spacer(),
                    const Text(
                      '48 ﷼',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const Text(
                  'More',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Center(child: CancelRideAvatar()),
              ],
            ),
          ),
        );
      },
    );
  }
}
