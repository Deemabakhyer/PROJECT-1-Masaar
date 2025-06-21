import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaar/models/card_model.dart';
import 'package:masaar/views/Home/payment_redirect_view.dart';
import 'package:masaar/widgets/custom widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:moyasar/moyasar.dart';

class ActiveCards extends StatefulWidget {
  const ActiveCards({Key? key}) : super(key: key);

  @override
  State<ActiveCards> createState() => _ActiveCardsState();
}

class _ActiveCardsState extends State<ActiveCards> {
  final PageController _controller = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  int? _selectedCardIndex;
  bool isLoading = true;

  List<CardModel> cards = [];
  PaymentConfig? paymentConfig;

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCardsFromDB();
  }

  Future<void> _loadCardsFromDB() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        setState(() => isLoading = false);
        return;
      }

      final response = await supabase
          .from('cards')
          .select()
          .eq('customer_id', user.id);

      setState(() {
        cards =
            (response as List).map((json) => CardModel.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error loading cards: $e');
    }
  }

  void _selectCard(int index) {
    final card = cards[index];
    setState(() {
      _selectedCardIndex = index;
      _cardNumberController.text = card.number;
      _expiryController.text = '${card.month}/${card.year}';
      _cvvController.text = card.cvc;
    });
  }

  void preparePaymentConfig(int amountInHalalas) {
    paymentConfig = PaymentConfig(
      publishableApiKey: 'pk_test_izoikq54kw7pHtSvZDmXcQmmDCEd2pyAEN52Si2P',
      amount: amountInHalalas,
      description: 'Manual Payment',
      metadata: {'source': 'ActiveCards'},
      creditCard: CreditCardConfig(saveCard: true, manual: false),
    );
  }

  Future<void> onSubmitCcForm() async {
    if (_selectedCardIndex == null || paymentConfig == null) {
      print('Card not selected or payment config is null');
      return;
    }

    final selectedCard = cards[_selectedCardIndex!];

    final source = CardPaymentRequestSource(
      creditCardData: CardFormModel(
        name: selectedCard.name,
        number: selectedCard.number,
        month: selectedCard.month,
        year: selectedCard.year,
        cvc: selectedCard.cvc,
      ),
      tokenizeCard: (paymentConfig!.creditCard as CreditCardConfig).saveCard,
      manualPayment: (paymentConfig!.creditCard as CreditCardConfig).manual,
    );

    final paymentRequest = PaymentRequest(paymentConfig!, source);

    final result = await Moyasar.pay(
      apiKey: paymentConfig!.publishableApiKey,
      paymentRequest: paymentRequest,
    );

    if (result is PaymentResponse) {
      final transactionUrl =
          (result.source as CardPaymentResponseSource).transactionUrl;

      if (transactionUrl != null) {
        // Open the transactionUrl in a WebView or browser
        Get.to(() => PaymentRedirectView(url: transactionUrl));
      } else {
        print('No transaction URL found');
      }
    } else {
      print('Unknown result type');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
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

                      _buildTextField('Card number', _cardNumberController),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Expiry date',
                              _expiryController,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              'CVV code',
                              _cvvController,
                              obscure: true,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

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

                      cards.isEmpty
                          ? const Center(child: Text("No cards found"))
                          : SizedBox(
                            height: 200,
                            child: PageView.builder(
                              controller: _controller,
                              itemCount: cards.length,
                              onPageChanged: (index) {
                                setState(() => _currentPage = index);
                              },
                              itemBuilder: (_, index) {
                                final card = cards[index];
                                final isSelected = _selectedCardIndex == index;

                                return GestureDetector(
                                  onTap: () => _selectCard(index),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: EdgeInsets.only(
                                      left: index == 0 ? 16 : 8,
                                      right: index == cards.length - 1 ? 16 : 8,
                                      top: _currentPage == index ? 0 : 12,
                                      bottom: _currentPage == index ? 0 : 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? const Color(0xFF6A42C2)
                                              : const Color(
                                                0xFF6A42C2,
                                              ).withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      border:
                                          isSelected
                                              ? Border.all(
                                                color: const Color.fromARGB(
                                                  255,
                                                  32,
                                                  32,
                                                  32,
                                                ),
                                                width: 2,
                                              )
                                              : null,
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Spacer(),
                                        Text(
                                          card.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Exp ${card.month}/${card.year}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '**** **** **** ${card.lastFour}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      const SizedBox(height: 16),

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

                      CustomButton(
                        text: 'Pay',
                        isActive: _selectedCardIndex != null,
                        onPressed: () {
                          if (_selectedCardIndex == null) return;
                          preparePaymentConfig(2500); // 25 SAR
                          onSubmitCcForm();
                        },
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        keyboardType: TextInputType.number,
        obscureText: obscure,
      ),
    );
  }
}
