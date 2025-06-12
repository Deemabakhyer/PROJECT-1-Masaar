import 'package:flutter/material.dart';
import 'package:masaar/widgets/custom%20widgets/custom_button.dart';
import 'package:masaar/widgets/custom%20widgets/custom_outlined_button.dart';

class CancelRidePopup extends StatefulWidget {
  const CancelRidePopup({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CancelRidePopupState createState() => _CancelRidePopupState();
}

class _CancelRidePopupState extends State<CancelRidePopup> {
  String? selectedReason;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 10),
            // Illustration (replace with your image asset or network)
            Image.asset(
              'images/undraw_cancel_7zdh.png',
              width: 96,
              height: 108,
            ),
            const SizedBox(height: 20),
            const Text(
              'Are you sure you want to cancel?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),
            const Text(
              'Your driver is on the way and may be close. Canceling now might inconvenience them.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF69696B),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                CustomOutlinedButton(
                  text: 'Keep My Ride',
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: "Cancel Ride",
                  isActive: true,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        String? selectedReason;
                        return Dialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
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
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Why are you canceling?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    RadioListTile<String>(
                                      title: const Text(
                                        'Driver taking too long',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF69696B),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      value: 'Driver taking too long',
                                      groupValue: selectedReason,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedReason = value;
                                        });
                                      },
                                    ),
                                    RadioListTile<String>(
                                      title: const Text(
                                        'Change of plans',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF69696B),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      value: 'Change of plans',
                                      groupValue: selectedReason,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedReason = value;
                                        });
                                      },
                                    ),
                                    RadioListTile<String>(
                                      title: const Text(
                                        'Wrong location',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF69696B),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      value: 'Wrong location',
                                      groupValue: selectedReason,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedReason = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    CustomOutlinedButton(
                                      text: 'Go Back',
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    CustomButton(
                                      text: 'Submit & Cancel',
                                      isActive: true,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  20,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: IconButton(
                                                        icon: const Icon(
                                                          Icons.close,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Image.asset(
                                                      'images/undraw_cancel_7zdh.png',
                                                      width: 96,
                                                      height: 108,
                                                    ),
                                                    const Text(
                                                      'Ride Canceled',
                                                      style: TextStyle(
                                                        fontSize: 28,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 15),
                                                    const Text(
                                                      'We understand plans can change. We hope to serve you again soon!',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Color(
                                                          0xFF69696B,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    CustomButton(
                                                      text: 'Back to Home',
                                                      isActive: true,
                                                      onPressed: () {
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
