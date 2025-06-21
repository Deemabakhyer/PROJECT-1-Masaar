import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaar/controllers/auth_controller.dart';
import 'package:masaar/models/ride_logs_model.dart';
import 'package:masaar/widgets/custom%20widgets/custom_ride_log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RideLogsView extends StatefulWidget {
  const RideLogsView({super.key});

  @override
  State<RideLogsView> createState() => _RideLogsViewState();
}

class _RideLogsViewState extends State<RideLogsView> {
  final SupabaseClient client = Supabase.instance.client;
  final AuthController authController = Get.find();

  Map<String, List<RideLogsModel>> ridesByMonth = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRides();
  }

  Future<void> fetchRides() async {
    final userId = authController.currentUser.value?.id;
    if (userId == null) return;

    final data = await client
        .from('rides')
        .select('ride_id, destination, created_at, customer_id, payment_id')
        .eq('customer_id', userId)
        .order('created_at', ascending: false);

    final rideLogs = <RideLogsModel>[];

    for (var item in data) {
      final payment =
          await client
              .from('payments')
              .select('amount, status')
              .eq('payment_id', item['payment_id'])
              .single();

      final enriched = {
        ...item,
        'amount': payment['amount'],
        'status': payment['status'],
      };
      rideLogs.add(RideLogsModel.fromJson(enriched));
    }

    setState(() {
      isLoading = false;
      ridesByMonth = groupByMonth(rideLogs);
    });
  }

  Map<String, List<RideLogsModel>> groupByMonth(List<RideLogsModel> rides) {
    final Map<String, List<RideLogsModel>> map = {};
    for (final ride in rides) {
      map.putIfAbsent(ride.monthYear, () => []).add(ride);
    }
    return map;
  }

  String formatMonthYear(String raw) {
    final parts = raw.split('-');
    final month = int.parse(parts[0]);
    final year = parts[1];
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[month]} $year';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (ridesByMonth.isEmpty) {
      return const Center(child: Text('No rides found.'));
    }

    return Container(
      color: Colors.white,
      child: ListView(
        children:
            ridesByMonth.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    child: Text(
                      formatMonthYear(entry.key),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...entry.value
                      .map(
                        (ride) => CustomRideLog(
                          destination: ride.destination,
                          status: ride.status,
                          date: ride.date.toLocal().toString().split(' ')[0],
                          price: ride.price.toStringAsFixed(2),
                          time: ride.time,
                        ),
                      )
                      .toList(),
                ],
              );
            }).toList(),
      ),
    );
  }
}
