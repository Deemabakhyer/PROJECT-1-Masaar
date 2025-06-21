import 'package:flutter/material.dart';
import 'package:masaar/views/Home/home_page.dart';
import 'package:masaar/views/Welcome/auth/login_screen.dart';
import 'package:masaar/widgets/custom%20widgets/bottom_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final bool isNewUser;

  const OtpScreen({Key? key, required this.email, required this.isNewUser})
    : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _focusedIndex = -1;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        setState(() {
          _focusedIndex =
              _focusNodes[i].hasFocus
                  ? i
                  : _focusedIndex == i
                  ? -1
                  : _focusedIndex;
        });
      });
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otpCode =>
      _controllers.map((controller) => controller.text.trim()).join();

  Widget _otpBox(int index) {
    final bool isFocused =
        _focusedIndex == index && _focusNodes[index].hasFocus;
    return SizedBox(
      width: 53,
      height: 41,
      child: Container(
        decoration:
            isFocused
                ? BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.50),
                      blurRadius: 3,
                      offset: const Offset(0, 3),
                    ),
                  ],
                )
                : null,
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6A42C2),
            fontFamily: 'inter',
          ),
          decoration: InputDecoration(
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF6A42C2), width: 1),
            ),
            filled: true,
            fillColor: isFocused ? Colors.white : const Color(0xFFF6F6F6),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Back button
              SizedBox(
                width: 54,
                height: 56,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF6A42C2),
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Title
              const Text(
                'Enter code',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'inter',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                'An SMS OTP was sent to: ${widget.email}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF919191),
                  fontFamily: 'inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  6,
                  (i) => Padding(
                    padding: EdgeInsets.only(right: i != 5 ? 5.0 : 0),
                    child: _otpBox(i),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Resend
              Row(
                children: [
                  const Text(
                    "Didn't get a code? ",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF919191),
                      fontFamily: 'inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        await supabase.auth.signInWithOtp(
                          email: widget.email.trim(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('OTP resent')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to resend OTP: $e')),
                        );
                      }
                    },
                    child: const Text(
                      "Resend",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6A42C2),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'inter',
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Verify button
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6a42c2).withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: SizedBox(
                    width: 374,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_otpCode.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please enter the full 6-digit OTP',
                              ),
                            ),
                          );
                          return;
                        }

                        try {
                          final supabase = Supabase.instance.client;
                          late final AuthResponse response;

                          if (widget.isNewUser) {
                            response = await supabase.auth.verifyOTP(
                              type: OtpType.signup,
                              token: _otpCode,
                              email: widget.email.trim(),
                            );

                            if (response.session != null &&
                                response.user != null) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                                (route) => false,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'OTP verification failed. Please check the code and try again.',
                                  ),
                                ),
                              );
                            }
                          } else {
                            response = await supabase.auth.verifyOTP(
                              type: OtpType.email,
                              token: _otpCode,
                              email: widget.email.trim(),
                            );

                            if (response.session != null &&
                                response.user != null) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BottomNavBar(),
                                ),
                                (route) => false,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'OTP verification failed. Please check the code and try again.',
                                  ),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('OTP verification failed: $e'),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color(0xFF563b9c);
                              }
                              return const Color(0xFF6A42C2);
                            }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                      ),
                      child: const Text(
                        'Verify',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'inter',
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
