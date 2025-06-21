import 'package:get/get.dart';
import 'package:masaar/views/Welcome/auth/login_screen.dart';
import 'package:masaar/views/Welcome/onBoarding/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    currentUser.value = _supabase.auth.currentUser;

    _supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if (session != null) {
        currentUser.value = session.user;
      } else {
        currentUser.value = null;
      }
    });

    super.onInit();
  }

  User? get user => currentUser.value;

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    currentUser.value = null;
    Get.off(LoginScreen());
  }
}
