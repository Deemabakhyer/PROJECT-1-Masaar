import 'package:flutter/material.dart';

class CustomRideLog extends StatelessWidget {
  final String destination;
  final String date;
  final String status;
  final String price;
  final String time;
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
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
          ),
        ],
      ),
    );
  }
}