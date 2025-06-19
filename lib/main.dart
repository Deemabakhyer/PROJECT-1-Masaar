import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:masaar/views/Home_views/active_cards.dart';
import 'package:masaar/views/Home_views/addcard.dart';
import 'package:masaar/views/Home_views/destinationconfirmation.dart';
import 'package:masaar/views/Home_views/home_page.dart';
import 'package:masaar/views/Home_views/package_types_page.dart';
import 'package:masaar/views/Home_views/payment_type_page.dart';
import 'package:masaar/views/Home_views/route_page.dart';
import 'package:masaar/views/Home_views/routeconfirmation.dart';
import 'package:masaar/widgets/bottom_nav_bar.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BottomNavBar(),
      getPages: [
        GetPage(name: '/Home', page: () => HomePage()),
        GetPage(name: '/route', page: () => RoutePage()),
        GetPage(name: '/pickup', page: () => Routeconfirmation()),
        GetPage(name: '/Destination', page: () => Destinationconfirmation()),
        GetPage(name: '/package_type', page: () => PackageTypesPage()),
        GetPage(name: '/payment', page: () => PaymentTypePage()),
        GetPage(name: '/card', page: () => AddCard()),
        GetPage(name: '/Actcard', page: () => ActiveCards()),
      ],
    ),
  );
}
