import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaar/widgets/custom%20widgets/cancel_ride_avatar.dart';

class DraggableBottomSheet extends StatefulWidget {
  const DraggableBottomSheet({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DraggableBottomSheetState createState() => _DraggableBottomSheetState();
}

class _DraggableBottomSheetState extends State<DraggableBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  int _currentPage = 0; // Keeps track of which content is showing

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // loading duration
    )..addListener(() {
      setState(() {});
      if (controller.value >= 1.0) {
        setState(() {
          _currentPage++;
          if (_currentPage == 2) {
            Get.toNamed('/ride_simulation');
          }
          // Restart the animation for cases that use the progress bar
          if (_currentPage != 2) {
            controller.forward(from: 0.0);
          }
        });
      }
    });

    controller.forward(); // start the animation
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildContent() {
    switch (_currentPage) {
      case 0:
        return _dgbs(
          context,
          'Looking For a Driver...',
          'Connecting to available drivers nearby',
        );

      case 1:
        return _dgbs(
          context,
          'Driver found',
          'Waiting for driver to confirm the order',
        );
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: _buildContent(),
          ),
        );
      },
    );
  }

  Widget _dgbs(
    BuildContext context,
    final String headerText,
    final String subHeaderText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 66.7,
          height: 7,
          decoration: BoxDecoration(
            color: const Color(0xFF9B9B9B),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            headerText,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              decorationColor: Colors.black,
              decorationThickness: 2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subHeaderText,
          style: const TextStyle(fontSize: 20, color: Color(0xFF919191)),
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6A42C2)),
          backgroundColor: const Color(0xFFF2F2F2),
          value: controller.value,
        ),
        const SizedBox(height: 24),
        CancelRideAvatar(),
        const SizedBox(height: 16),
      ],
    );
  }
}
