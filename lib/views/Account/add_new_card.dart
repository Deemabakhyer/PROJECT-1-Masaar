import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaar/controllers/auth_controller.dart';
import 'package:masaar/widgets/custom%20widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddNewCard extends StatefulWidget {
  final VoidCallback? onCardAdded;

  const AddNewCard({Key? key, this.onCardAdded}) : super(key: key);

  @override
  State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  void formatCardNumber(String input) {
    final cleaned = input.replaceAll(RegExp(r'\s+'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < cleaned.length; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(cleaned[i]);
    }
    cardNumberController.value = TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
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
        title: const Text(
          'Wallet',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
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
                child: Column(
                  children: [
                    TextField(
                      controller: cardNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Card number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 19,
                      onChanged: formatCardNumber,
                    ),
                    TextField(
                      controller: cardHolderController,
                      decoration: const InputDecoration(
                        labelText: 'card holder name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ],
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
                      child: TextField(
                        controller: expiryController,
                        decoration: const InputDecoration(
                          labelText: 'Expiry date (MM/YY)',
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
                      child: TextField(
                        controller: cvvController,
                        decoration: const InputDecoration(
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

              // Save Button
              CustomButton(
                text: 'Add card',
                isActive: true,
                onPressed: () async {
                  final cardNumber = cardNumberController.text.replaceAll(
                    ' ',
                    '',
                  );
                  final expiry = expiryController.text.trim();
                  final cvv = cvvController.text.trim();
                  final cardholder = cardHolderController.text.trim();

                  final customerId = Get.find<AuthController>().user?.id;

                  if (cardNumber.isEmpty ||
                      expiry.isEmpty ||
                      cvv.isEmpty ||
                      customerId == null) {
                    Get.snackbar(
                      'Error',
                      'Please fill all fields',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  // Parse expiry date (MM/YY or MM/YYYY)
                  final parts = expiry.contains('/') ? expiry.split('/') : [];
                  if (parts.length != 2 || parts[0].length != 2) {
                    Get.snackbar(
                      'Invalid Format',
                      'Expiry date must be in MM/YY format',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  final month = parts[0];
                  var year = parts[1];
                  if (year.length == 2) {
                    year = '20$year';
                  }

                  try {
                    final supabase = Supabase.instance.client;
                    await supabase.from('cards').insert({
                      'number': cardNumber,
                      'month': month,
                      'year': year,
                      'cvc': int.parse(cvv),
                      'name': cardholder,
                      'customer_id': customerId,
                    });

                    widget.onCardAdded?.call();
                    Get.back();
                    Get.snackbar(
                      'Success',
                      'Card added successfully',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  } catch (e) {
                    print('Add card error: $e');
                    Get.snackbar(
                      'Error',
                      'Failed to add card: $e',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
