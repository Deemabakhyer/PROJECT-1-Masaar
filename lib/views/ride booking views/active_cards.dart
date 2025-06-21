import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaar/widgets/custom%20widgets/custom_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ActiveCards extends StatefulWidget {
  const ActiveCards({Key? key}) : super(key: key);

  @override
  State<ActiveCards> createState() => _ActiveCardsState();
}

class _ActiveCardsState extends State<ActiveCards> {
  final PageController _controller = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  final List<Map<String, String>> cards = [
    {"name": "Ahmad Sindi", "exp": "09/2025"},
    {"name": "Ali Nader", "exp": "12/2026"},
    {"name": "Sara Ahmed", "exp": "05/2027"},
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: SizedBox(
            height: 50,
            width: 50,
            child: Image.asset('images/back_button.png'),
          ),
        ),

        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                children: [
                  SizedBox(width: 8),
                  Text(
                    "Cards",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Card Number Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Card number',
                    prefixIcon: Image.asset(
                      'images/Card_numb.png',
                      width: 31.38,
                      height: 31.38,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 16),

              // Expiry and CVV
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          labelText: 'Expiry date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          labelText: 'CVV code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Credit Cards Title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Credit Cards',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Cards Carousel
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: cards.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (_, index) {
                    final card = cards[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(
                        left: index == 0 ? 16 : 8,
                        right: index == cards.length - 1 ? 16 : 8,
                        top: _currentPage == index ? 0 : 12,
                        bottom: _currentPage == index ? 0 : 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A42C2),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('images/visa.png', height: 64, width: 64),
                          const Spacer(),
                          Text(
                            card['name'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Exp ${card['exp']}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            '0000 0000 0000 0000',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Page Indicator
              SmoothPageIndicator(
                controller: _controller,
                count: cards.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Color(0xFF6A42C2),
                  dotColor: Color(0xFFADADAD),
                  dotHeight: 12,
                  dotWidth: 12,
                  expansionFactor: 3,
                  spacing: 6,
                ),
              ),

              const SizedBox(height: 24),

              const Divider(indent: 40, endIndent: 40),
              const SizedBox(height: 24),

              // Card Logos using Stack inside SizedBox
              SizedBox(
                height: 80,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 30,
                      right: 120,
                      child: Row(
                        children: [
                          Image.asset(
                            "images/visa_logo.png",
                            width: 60,
                            height: 40,
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 120,
                      child: Row(
                        children: [
                          Image.asset('images/mada.png', width: 60, height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Pay Button
              CustomButton(
                text: 'Pay',
                isActive: true,
                onPressed: () {
                  // Action to add card
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
