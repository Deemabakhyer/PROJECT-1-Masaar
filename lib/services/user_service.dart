import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = supabase.auth.currentUser;

    if (user == null) return null;

    final response =
        await supabase
            .from('customers')
            .select(
              'customer_id, first_name, last_name, email, phone_number, profile_image',
            )
            .eq('email', user.email!)
            .maybeSingle();

    return response;
  }
}
