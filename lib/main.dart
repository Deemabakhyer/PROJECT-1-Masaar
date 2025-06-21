import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:masaar/controllers/settings_controllers/account_controller.dart';
import 'package:masaar/controllers/auth_controller.dart';
import 'package:masaar/views/Home/active_cards.dart';
import 'package:masaar/views/Home/home_page.dart' as home;
import 'package:masaar/views/Welcome/onBoarding/splash_screen.dart';
import 'package:masaar/views/ride%20booking/assigning_driver.dart';
import 'package:masaar/views/ride%20booking/my_chat.dart';
import 'package:masaar/views/ride%20booking/my_map.dart';
import 'package:masaar/views/ride%20booking/package_types_page.dart';
import 'package:masaar/views/ride%20booking/payment_type_page.dart';
import 'package:masaar/views/ride%20booking/ride_simulation.dart';
import 'package:masaar/widgets/custom%20widgets/bottom_nav_bar.dart';
import 'package:masaar/widgets/popups/submit_rating.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// main.dart

import 'package:masaar/views/ride%20booking/active_cards.dart';
import 'package:masaar/views/ride%20booking/destination_confirmation.dart';
import 'package:masaar/views/ride%20booking/home_page.dart';
import 'package:masaar/views/ride%20booking/package_types_page.dart';
import 'package:masaar/views/ride%20booking/payment_type_page.dart';
import 'package:masaar/views/ride%20booking/route_page.dart';
import 'package:masaar/views/ride%20booking/route_confirmation.dart';
import 'package:masaar/views/ride%20booking/assigning_driver.dart';
import 'package:masaar/views/ride%20booking/my_chat.dart';
import 'package:masaar/views/ride%20booking/my_map.dart';
import 'package:masaar/widgets/custom%20widgets/bottom_nav_bar.dart';
import 'package:masaar/views/ride%20booking/ride_simulation.dart';
import 'package:masaar/widgets/popups/submit_rating.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (await Permission.locationWhenInUse.isDenied) {
    await Permission.locationWhenInUse.request();
  }

  await Supabase.initialize(
    url: 'https://vrsczitnkvjsterzxqpr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZyc2N6aXRua3Zqc3Rlcnp4cXByIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwMzk0MDEsImV4cCI6MjA2MjYxNTQwMX0.e9JkJnDntFXaW5zgCcS-A1ebMuZOfmFW59AADrB3OM4',
  );

  Get.put(AccountController());
  Get.put(AuthController());

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      home: const StartupScreen(),

      getPages: [
        GetPage(name: '/Home', page: () => home.HomePage()),
        GetPage(name: '/route', page: () => RoutePage()),
        GetPage(name: '/pickup', page: () => const Routeconfirmation()),
        GetPage(
          name: '/Destination',
          page: () => const Destinationconfirmation(),
        ),
      ],
    );
  }
}

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 500)),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (session != null && session.user != null) {
          return const BottomNavBar();
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}
