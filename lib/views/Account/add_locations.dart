import 'package:flutter/material.dart';
import 'package:masaar/widgets/custom%20widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddLocationPage extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const AddLocationPage({Key? key, this.initialData}) : super(key: key);

  @override
  AddLocationPageState createState() => AddLocationPageState();
}

class AddLocationPageState extends State<AddLocationPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _detailsController;

  static const Color _labelColor = Color(0xFF6A42C2);
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialData?['name'] ?? '',
    );
    _addressController = TextEditingController(
      text: widget.initialData?['address'] ?? '',
    );
    _cityController = TextEditingController(
      text: widget.initialData?['city'] ?? '',
    );
    _detailsController = TextEditingController(
      text: widget.initialData?['details'] ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _saveLocationToDB() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      _showErrorDialog('User not authenticated.');
      return;
    }
    debugPrint('User ID: $userId');
    try {
      final response =
          await supabase.from('locations').insert({
            'customer_id': userId,
            'location_name': _nameController.text,
            'address': _addressController.text,
            'city': _cityController.text,
            'additional_details': _detailsController.text,
            'created_at': DateTime.now().toIso8601String(),
          }).select();

      if (response == null || response.isEmpty) {
        _showErrorDialog('Failed to add location.');
      } else {
        Get.back();
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('OK')),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Get.back();
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: SizedBox(
            height: 50,
            width: 50,
            child: Image.asset('images/back_button.png'),
          ),
        ),
        title: const Text(
          'Add a location',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Location name',
                style: TextStyle(
                  color: _labelColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'College, Home',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text(
                'Address',
                style: TextStyle(
                  color: _labelColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: 'Al-Madinah Al-Munawarah, 12345',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text(
                'City',
                style: TextStyle(
                  color: _labelColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  hintText: 'Medina',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text(
                'Additional details',
                style: TextStyle(
                  color: _labelColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  hintText: 'Gate 2, Building B',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Save location',
                isActive: true,
                onPressed: () {
                  _saveLocationToDB();
                  // if (_formKey.currentState!.validate()) {
                  // }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
