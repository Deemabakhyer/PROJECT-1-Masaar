import 'package:flutter/material.dart';
import 'package:masaar/views/map.dart';
import 'package:masaar/widgets/draggable%20scrollable%20bottom%20sheets/draggable_bottom_sheet.dart';

class AssigningDriver extends StatelessWidget {
  const AssigningDriver({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [Map(), DraggableBottomSheet()]));
  }
}
