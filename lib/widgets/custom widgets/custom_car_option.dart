import 'package:flutter/material.dart';

class CustomCarOption extends StatelessWidget {
  const CustomCarOption({
    super.key,
    required this.carOption,
    required this.price,
    required this.arrivalTime,
    required this.carImg,
    required this.capacity,
  });

  final String carOption;
  final String price;
  final String arrivalTime;
  final String carImg;
  final String capacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: const Color(0xFFE0E0E0), width: 1.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(carImg, width: 65, height: 60, fit: BoxFit.contain),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      carOption,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        SizedBox(width: 4),
                        Text(
                          arrivalTime,
                          style: TextStyle(
                            color: const Color(0xFF69696B),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 20),
                        Icon(
                          Icons.person_outline,
                          size: 25,
                          color: const Color(0xFF69696B),
                        ),
                        SizedBox(width: 4),
                        Text(
                          capacity,
                          style: TextStyle(
                            color: const Color(0xFF69696B),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                price,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 4),

              Image.asset('images/saudiriyalsymbol.png', height: 16, width: 18),
            ],
          ),
        ],
      ),
    );
  }
}

// How to use widget:
// CustomCarOption(
//           carOption: 'Saver',
//           price: '35',
//           arrivalTime: '9 min',
//           carImg: 'images/saver-car.png',
//           capacity: '4',
//         ),
