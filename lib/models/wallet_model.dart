class Wallet {
  final int walletId;
  final double balance;
  final String? cardNumber;
  final String? expireDate;
  final int? cvv;
  final String? customerId;

  Wallet({
    required this.walletId,
    required this.balance,
    this.cardNumber,
    this.expireDate,
    this.cvv,
    this.customerId,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      walletId: json['wallet_id'],
      balance: double.tryParse(json['balance'].toString()) ?? 0.0,
      cardNumber: json['card_number'],
      expireDate: json['expire_date'],
      cvv: json['CVV'],
      customerId: json['customer_id'],
    );
  }

  get firstName => null;

  get lastName => null;
}
