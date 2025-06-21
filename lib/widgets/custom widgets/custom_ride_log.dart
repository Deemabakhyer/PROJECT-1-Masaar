import 'package:flutter/material.dart';

class CustomRideLog extends StatelessWidget {
  final String destination;
  final String date;
  final String status;
  final String price;
  final String time;
<<<<<<< HEAD

=======
>>>>>>> origin/main
  const CustomRideLog({
    super.key,
    required this.destination,
    required this.status,
    required this.date,
    required this.price,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
<<<<<<< HEAD
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 53, 53, 53),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            status == 'Cancelled'
                ? 'images/cancelled_car.png'
                : 'images/car.png',
            width: 48,
            height: 48,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (date.isNotEmpty)
                  Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          color: Color(0xFF919191),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(' - '),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(
                          color: Color(0xFF919191),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 4),
                Text(
                  destination,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
=======
      color: Colors.white,
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (status == 'Cancelled')
            Image.asset('images/cancelled_car.png')
          else
            Image.asset('images/car.png'),

          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      color: Color(0xFF919191),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(' - '),
                  if (status == 'Cancelled')
                    Text(
                      status,
                      style: TextStyle(
                        color: Color(0xFF919191),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else
                    Text(
                      time,
                      style: TextStyle(
                        color: Color(0xFF919191),
>>>>>>> origin/main
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
<<<<<<< HEAD
                    const SizedBox(width: 4),
                    Image.asset('images/SAR.png', width: 20, height: 20),
                  ],
                ),
              ],
            ),
=======
                ],
              ),
              Text(
                destination,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Text(
                    price,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 4),
                  Image.asset('images/SAR.png'),
                ],
              ),
            ],
>>>>>>> origin/main
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> origin/main
