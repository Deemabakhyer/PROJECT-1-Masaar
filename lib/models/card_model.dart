class CardModel {
  final String name;
  final String number;
  final String month;
  final String year;
  final String cvc;

  CardModel({
    required this.name,
    required this.number,
    required this.month,
    required this.year,
    required this.cvc,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      name: json['name'] ?? '',
      number: json['number'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? '',
      cvc: json['cvc'] ?? '',
    );
  }

  String get lastFour =>
      number.length >= 4 ? number.substring(number.length - 4) : '0000';
  String get expiryMonth => month;
  String get expiryYear => year;
}
