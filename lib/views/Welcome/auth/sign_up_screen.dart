import 'package:flutter/material.dart';
import 'package:masaar/main.dart';
import 'package:masaar/views/Welcome/auth/otp_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'otp_screen.dart';

final supabase = Supabase.instance.client;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  bool _isFirstNameFocused = false;
  bool _isLastNameFocused = false;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isConfirmPasswordFocused = false;
  bool isPasswordValid = false;
  bool isNumberValid = false;
  bool isSpecialCharValid = false;

  void _validatePassword(String value) {
    setState(() {
      isPasswordValid = value.length >= 8;
      isNumberValid = RegExp(r'[0-9]').hasMatch(value);
      isSpecialCharValid = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
    });
  }

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });
    _confirmPasswordFocusNode.addListener(() {
      setState(() {
        _isConfirmPasswordFocused = _confirmPasswordFocusNode.hasFocus;
      });
    });
    _firstNameFocusNode.addListener(() {
      setState(() {
        _isFirstNameFocused = _firstNameFocusNode.hasFocus;
      });
    });
    _lastNameFocusNode.addListener(() {
      setState(() {
        _isLastNameFocused = _lastNameFocusNode.hasFocus;
      });
    });
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A42C2),
      body: SafeArea(
        child: Column(
          children: [
            // Top section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF6A42C2),
                      ),
                      iconSize: 24,
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "New here?\nLet's get you moving!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'inter',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Create your account to explore routes and book your rides instantly",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFE0E0E0),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'inter',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Bottom card
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 24),
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'inter',
                            ),
                          ),
                        ),
                      ),
                      // First and Last Name
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'First name',
                                  style: TextStyle(
                                    color: Color(0xff69696b),
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  height: 45,
                                  child: TextField(
                                    controller: firstNameController,
                                    focusNode: _firstNameFocusNode,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          _isFirstNameFocused
                                              ? Colors.white
                                              : const Color(0xFFF2F2F2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF6A42C2),
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 14,
                                            horizontal: 12,
                                          ),
                                      isDense: true,
                                    ),
                                    style: const TextStyle(fontFamily: 'inter'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Last name',
                                  style: TextStyle(
                                    color: Color(0xff69696b),
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  height: 45,
                                  child: TextField(
                                    controller: lastNameController,
                                    focusNode: _lastNameFocusNode,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          _isLastNameFocused
                                              ? Colors.white
                                              : const Color(0xFFF2F2F2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF6A42C2),
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 14,
                                            horizontal: 12,
                                          ),
                                      isDense: true,
                                    ),
                                    style: const TextStyle(fontFamily: 'inter'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                              color: Color(0xff69696b),
                              fontFamily: 'inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            height: 45,
                            child: TextField(
                              controller: emailController,
                              focusNode: _emailFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    _isEmailFocused
                                        ? Colors.white
                                        : const Color(0xFFF2F2F2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF6A42C2),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                                isDense: true,
                              ),
                              style: const TextStyle(fontFamily: 'inter'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Password and Confirm Password
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Password',
                                  style: TextStyle(
                                    color: Color(0xff69696b),
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                TextField(
                                  controller: passwordController,
                                  focusNode: _passwordFocusNode,
                                  obscureText: true,
                                  onChanged: _validatePassword,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor:
                                        _isPasswordFocused
                                            ? Colors.white
                                            : const Color(0xFFF2F2F2),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF6A42C2),
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 12,
                                    ),
                                    isDense: true,
                                  ),
                                  style: const TextStyle(fontFamily: 'inter'),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 3,
                                  margin: const EdgeInsets.only(top: 2),
                                  decoration: BoxDecoration(
                                    color:
                                        (isPasswordValid &&
                                                isNumberValid &&
                                                isSpecialCharValid)
                                            ? Colors.green
                                            : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Confirm password',
                                  style: TextStyle(
                                    color: Color(0xff69696b),
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  height: 45,
                                  child: TextField(
                                    focusNode: _confirmPasswordFocusNode,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          _isConfirmPasswordFocused
                                              ? Colors.white
                                              : const Color(0xFFF2F2F2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF6A42C2),
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 14,
                                            horizontal: 12,
                                          ),
                                      isDense: true,
                                    ),
                                    style: const TextStyle(fontFamily: 'inter'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Password requirements
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color:
                                      isPasswordValid
                                          ? Colors.green
                                          : Colors.grey,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  '8 characters minimum',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'inter',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color:
                                      isNumberValid
                                          ? Colors.green
                                          : Colors.grey,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'at least one number',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'inter',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color:
                                      isSpecialCharValid
                                          ? Colors.green
                                          : Colors.grey,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'at least one special character',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'inter',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: SizedBox(
                          width: 374,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _submitData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A42C2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: const Text(
                              'Create a new account',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'inter',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text.rich(
                            TextSpan(
                              text: 'By signing up, you agree to our ',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xff919191),
                                fontFamily: 'inter',
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: const TextStyle(
                                    color: Color(0xff919191),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const TextSpan(text: ', acknowledge our '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: const TextStyle(
                                    color: Color(0xff919191),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const TextSpan(
                                  text: ', and confirm that you\'re over 18.',
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitData() async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        password.isEmpty ||
        email.isEmpty)
      return;

    try {
      final response = await supabase.auth.signUp(
        password: passwordController.text,
        email: emailController.text,
      );
      if (response.user == null) {
        throw Exception('Sign up failed');
      }

      await supabase.from('customers').insert({
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'customer_id': response.user!.id,
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OtpScreen(email: email, isNewUser: true),
        ),
      );
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }
}
