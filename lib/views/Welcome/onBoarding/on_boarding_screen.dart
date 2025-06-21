import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';
import 'package:masaar/views/Welcome/auth/login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                children: [
                  _buildOnboardingPage(
                    imagePath: 'images/oboarding1.svg',
                    title: 'Book a Ride in Seconds',
                    description:
                        'Get a ride when you need it. Anywhere, anytime — no hassle, no delays.',
                  ),
                  _buildOnboardingPage(
                    imagePath: 'images/oboarding2.svg',
                    title: 'Know Exactly Where You’re Going',
                    description:
                        'Track your driver in real time and stay updated every step of the trip.',
                  ),
                  _buildOnboardingPage(
                    imagePath: 'images/oboarding3.svg',
                    title: 'Safe, Comfortable, On Time',
                    description:
                        'Enjoy a smooth ride with trusted drivers and reliable service every day.',
                  ),
                ],
              ),
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: Color(0xFF6A42C2),
                dotColor: Color(0xFFADADAD),
                dotHeight: 15,
                dotWidth: 15,
                expansionFactor: 3,
                spacing: 8,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.off(() => LoginScreen());
                    },
                    child: Text(
                      'skip',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6A42C2),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_controller.page == 2) {
                        Get.off(() => LoginScreen());
                      } else {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      'next',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String imagePath,
    required String title,
    required String description,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(imagePath, width: 440, height: 350, fit: BoxFit.cover),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF919191),
            ),
          ),
        ),
      ],
    );
  }
}
