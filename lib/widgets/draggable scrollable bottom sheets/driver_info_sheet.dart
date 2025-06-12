import 'package:flutter/material.dart';
import 'package:masaar/views/chat.dart';
import 'package:masaar/widgets/popups/cancel_ride_popup.dart';

class DriverInfo extends StatelessWidget {
  const DriverInfo({super.key, required this.state});
  final String state;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            Image.asset('images/comfort-car.png', width: 114.89, height: 81.58),
          ],
        ),
        // Car details and driver
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFADC8F5),
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
                  Text(
                    'White Toyota Yaris',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF919191),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ABC 1234',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xFF69696B),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Hassan',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF919191),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      Text('4.5', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.grey[200],
                padding: const EdgeInsets.all(12),
              ),
              child: Icon(Icons.call, color: const Color(0xFF6A42C2)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyChat()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.grey[200],
                padding: const EdgeInsets.all(12),
              ),
              child: Icon(Icons.message, color: const Color(0xFF6A42C2)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Divider(),
        // Route section
        const SizedBox(height: 8),
        Text(
          'My route',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.location_on, color: const Color(0xFF6A42C2)),
          title: Text(
            'Wadi Makkah Company',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0XFF69696B),
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.add, color: const Color(0xFF6A42C2)),
          title: Text(
            'Add stop',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0XFF919191),
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.place, color: const Color(0xFF6A42C2)),
          title: Text(
            'Masjid Al-Haram',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0XFF69696B),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyChat()),
              );
            },
            child: Text(
              'Edit destinations',
              style: TextStyle(color: const Color(0xFF6A42C2)),
            ),
          ),
        ),
        Divider(),

        // Payment section
        const SizedBox(height: 8),
        Text(
          'Payment method',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Image.asset('images/cash.png', width: 56, height: 41),
            const SizedBox(width: 8),
            Text(
              'cash',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: const Color(0XFF69696B),
              ),
            ),
            Spacer(),
            Text(
              '48 ﷼',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Divider(),
        Text(
          'More',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        // Bottom actions
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
                      builder: (context) => CancelRidePopup(),
                    );
                  },
                  icon: Icon(Icons.cancel, color: const Color(0xFF6A42C2)),
                ),
                Text('Cancel ride'),
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyChat()),
                    );
                  },
                  icon: Icon(Icons.share, color: const Color(0xFF6A42C2)),
                ),
                Text('Share ride details'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
