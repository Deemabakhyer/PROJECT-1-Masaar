class RideLogsModel {
  final String destination;
  final DateTime date;
  final String status;
  final double price;
  final String time;

  RideLogsModel({
    required this.destination,
    required this.date,
    required this.status,
    required this.price,
    required this.time,
  });

  factory RideLogsModel.fromJson(Map<String, dynamic> json) {
    return RideLogsModel(
      destination: json['destination'] ?? '',
      date: DateTime.parse(json['created_at']),
      status: json['status'] ?? 'Completed',
      price: double.tryParse(json['amount'].toString()) ?? 0,
      time: DateTime.parse(
        json['created_at'],
      ).toLocal().toString().split(' ')[1].substring(0, 5),
    );
  }

  String get monthYear => '${date.month}-${date.year}';
}
