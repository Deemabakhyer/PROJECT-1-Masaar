import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaar/widgets/custom_button.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final FocusNode cardFocus = FocusNode();
  final FocusNode expiryFocus = FocusNode();
  final FocusNode cvvFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    cardFocus.addListener(() => setState(() {}));
    expiryFocus.addListener(() => setState(() {}));
    cvvFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    cardFocus.dispose();
    expiryFocus.dispose();
    cvvFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Material(
            elevation: 30,
            color: Colors.transparent,
            child: Container(
              height: 850,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Back button + title
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),

                    Row(
                      children: [
                        const SizedBox(width: 8),
                        const Text(
                          "New Card",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Card Number Field with Shadow
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
                        focusNode: cardFocus,
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

                    // Expiry & CVV Fields with Shadow
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
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
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
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
                              boxShadow: [
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
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              obscureText: true,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      "Your card details are securely encrypted and protected",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: "Add card",
                        isActive: true,
                        onPressed: () {
                          // logic
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
