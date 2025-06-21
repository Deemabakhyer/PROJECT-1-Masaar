import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaar/models/card_model.dart';
import 'package:masaar/views/Account/add_new_card.dart';
import 'package:masaar/widgets/custom%20widgets/custom_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WalletView extends StatefulWidget {
  final String firstName;
  final String lastName;

  const WalletView({Key? key, required this.firstName, required this.lastName})
    : super(key: key);

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  final PageController _controller = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  double walletBalance = 0.0;
  List<CardModel> cards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWalletAndCards();
  }

  Future<void> _loadWalletAndCards() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final walletData =
          await supabase
              .from('wallets')
              .select()
              .eq('customer_id', user.id)
              .maybeSingle();

      final cardsData = await supabase
          .from('cards')
          .select()
          .eq('customer_id', user.id);

      setState(() {
        walletBalance =
            walletData != null
                ? double.tryParse(walletData['balance'].toString()) ?? 0.0
                : 0.0;
        cards =
            (cardsData as List)
                .map((json) => CardModel.fromJson(json))
                .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error loading wallet/cards: $e');
    }
  }

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
          onPressed: () => Navigator.of(context).pop(),
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
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    // Wallet Balance Box
                    Container(
                      height: 120,
                      width: 371,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A42C2).withOpacity(0.25),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Wallet Balance',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6A42C2),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Image.asset(
                                'images/WhiteSAR.png',
                                color: Colors.white,
                                height: 48,
                                width: 48,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                walletBalance.toStringAsFixed(2),
                                style: const TextStyle(
                                  color: Color(0xFF6A42C2),
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Align(
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
                    ),

                    SizedBox(
                      height: 200,
                      child:
                          cards.isEmpty
                              ? Center(child: Text('No cards found'))
                              : PageView.builder(
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
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image(
                                          image: AssetImage('images/visa.png'),
                                          height: 64,
                                          width: 64,
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
                                        Text(
                                          'Exp ${card.expiryMonth ?? ''}/${card.expiryYear ?? ''}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            Text(
                                              widget.firstName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              widget.lastName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                    ),

                    const SizedBox(height: 16),

                    SmoothPageIndicator(
                      controller: _controller,
                      count: cards.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: const Color(0xFF6A42C2),
                        dotColor: const Color(0xFFADADAD),
                        dotHeight: 12,
                        dotWidth: 12,
                        expansionFactor: 3,
                        spacing: 6,
                      ),
                    ),

                    Divider(endIndent: 40, indent: 40),

                    const Spacer(),

                    CustomButton(
                      text: 'Add a new card',
                      isActive: true,
                      onPressed: () {
                        Get.to(
                          () => AddNewCard(onCardAdded: _loadWalletAndCards),
                        );
                      },
                      // onPressed: () {
                      //   Get.to(
                      //     () => AddNewCard(onCardAdded: _loadWalletAndCards),
                      //   );
                      // },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
    );
  }
}
