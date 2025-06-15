import 'package:flutter/material.dart';
import 'package:masaar/views/chat.dart';
import 'package:masaar/widgets/popups/cancel_ride_popup.dart';

class DriverInfo extends StatelessWidget {
  const DriverInfo({super.key, required this.state});
  final String state;

  @override
  Widget build(BuildContext context) {
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

                // Top section: Arrival info and car
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state,
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
                const SizedBox(height: 16),

                // Car details and driver
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFADC8F5),
                      child: Text(
                        'H',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'White Toyota Yaris',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF919191),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'ABC 1234',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF69696B),
                            ),
                          ),
                          Row(
                            children: const [
                              Text(
                                'Hassan',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF919191),
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.star, size: 16, color: Colors.amber),
                              Text('4.5', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(Icons.call, color: Color(0xFF6A42C2)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyChat(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(Icons.message, color: Color(0xFF6A42C2)),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(),

                // Route section
                const SizedBox(height: 8),
                const Text(
                  'My route',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const ListTile(
                  leading: Icon(Icons.location_on, color: Color(0xFF6A42C2)),
                  title: Text(
                    'Wadi Makkah Company',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF69696B),
                    ),
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.add, color: Color(0xFF6A42C2)),
                  title: Text(
                    'Add stop',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF919191),
                    ),
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.place, color: Color(0xFF6A42C2)),
                  title: Text(
                    'Masjid Al-Haram',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF69696B),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyChat(),
                        ),
                      );
                    },
                    child: const Text(
                      'Edit destinations',
                      style: TextStyle(color: Color(0xFF6A42C2)),
                    ),
                  ),
                ),

                const Divider(),

                // Payment section
                const SizedBox(height: 8),
                const Text(
                  'Payment method',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset('images/cash.png', width: 56, height: 41),
                    const SizedBox(width: 8),
                    const Text(
                      'cash',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF69696B),
                      ),
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

                // More section
                const Text(
                  'More',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const CancelRidePopup(),
                            );
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Color(0xFF6A42C2),
                          ),
                        ),
                        const Text('Cancel ride'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyChat(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.share,
                            color: Color(0xFF6A42C2),
                          ),
                        ),
                        const Text('Share ride details'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
