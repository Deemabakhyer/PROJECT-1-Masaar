import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaar/widgets/custom%20widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubmitRating extends StatefulWidget {
  const SubmitRating({super.key, this.driverID});
  final int? driverID;

  @override
  State<SubmitRating> createState() => _SubmitRatingState();
}

class _SubmitRatingState extends State<SubmitRating> {
  int _rating = 3; // Default rating
  final TextEditingController _commentController = TextEditingController();
  Map<String, dynamic>? _driver;

  @override
  void initState() {
    super.initState();
    fetchDriverInfo().then((_) {
      Future.delayed(const Duration(seconds: 2), () {
        _showRatingDialog();
      });
    });
  }

  Future<void> fetchDriverInfo() async {
    final response =
        await Supabase.instance.client
            .from('drivers')
            .select('''
          driver_id,
          name,
          rating,
          phone_number,
          driver_image,
          vehicles!Driver_vehicle_id_fkey(
            brand,
            model,
            plate_number,
            color
          )
        ''')
            .eq('driver_id', widget.driverID!)
            .single();

    setState(() {
      _driver = response;
    });
  }

  _submitRating() async {
    final supabase = Supabase.instance.client;
    final newRating = _rating.toDouble();

    try {
      final response =
          await supabase
              .from('drivers')
              .select('rating, rating_count')
              .eq('driver_id', widget.driverID!)
              .single();
      final currentRating = (response['rating'] ?? 0).toDouble();
      final ratingCount = (response['rating_count'] ?? 0).toInt();

      final updatedCount = ratingCount + 1;
      final updatedRating =
          ((currentRating * ratingCount) + newRating) / updatedCount;

      await supabase
          .from('drivers')
          .update({'rating': updatedRating, 'rating_count': updatedCount})
          .eq('driver_id', widget.driverID!);

      Get.back();
      Get.snackbar(
        'Thank you!',
        'Your review has been submitted.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        int localRating = _rating;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            _driver!['driver_image'] != null
                                ? NetworkImage(_driver!['driver_image'])
                                : null,
                        child:
                            _driver!['driver_image'] == null
                                ? Text(
                                  _driver!['name'][0],
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                )
                                : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _driver != null
                            ? _driver!['name'] ?? "Unknown"
                            : "Loading...",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _driver != null && _driver!['vehicles'] != null
                            ? _driver!['vehicles']['plate_number'] ??
                                "Unknown Plate"
                            : "Unknown Plate",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Text(
                        "How was your ride?",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            onPressed: () {
                              setStateDialog(() {
                                localRating = index + 1;
                                _rating = localRating;
                              });
                            },
                            icon: Icon(
                              index < localRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color:
                                  index < localRating
                                      ? Colors.amber
                                      : Colors.grey,
                              size: 32,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _commentController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "Additional comments..",
                          filled: true,
                          fillColor: const Color(0xFFF2F2F2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Submit Review',
                          isActive: true,
                          onPressed: _submitRating,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/ride-completed.png'),
            const SizedBox(height: 16),
            const Text('You have successfully reached your journey.'),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Return to home',
              isActive: true,
              onPressed: () {
                Get.toNamed('/Home');
              },
            ),
          ],
        ),
      ),
    );
  }
}
