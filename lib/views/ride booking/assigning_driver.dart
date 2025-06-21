import 'package:flutter/material.dart';
import 'package:masaar/views/ride%20booking/my_map.dart';
import 'package:masaar/widgets/bottom%20sheets/driver_loading.dart';

class AssigningDriver extends StatelessWidget {
  const AssigningDriver({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [MyMap(), DriverLoading()]));
  }
}
