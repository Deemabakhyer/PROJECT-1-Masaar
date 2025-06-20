import 'package:flutter/material.dart';
import 'package:masaar/widgets/popups/submit_rating_popup.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SubmitRating(driverID: 2,)
    );
  }
}
