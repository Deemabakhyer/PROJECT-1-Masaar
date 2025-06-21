import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaar/widgets/custom%20widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_locations.dart';
import 'package:masaar/controllers/auth_controller.dart';

class SavedLocationsPage extends StatefulWidget {
  @override
  _SavedLocationsPageState createState() => _SavedLocationsPageState();
}

class _SavedLocationsPageState extends State<SavedLocationsPage> {
  List<Map<String, dynamic>> locations = [];
  bool isLoading = true;
  RealtimeChannel? _channel;

  final Color iconColor = const Color(0xFF563B9C);
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _initializeRealtimeAndFetch();
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }

  Future<void> _initializeRealtimeAndFetch() async {
    await _fetchLocations();
    _setupRealtimeSubscription();
  }

  void _setupRealtimeSubscription() {
    final userId = Get.find<AuthController>().user?.id;
    if (userId == null) return;

    _channel = supabase.channel('locations_channel');

    _channel!.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'locations',
      callback: (payload) {
        _fetchLocations(); // Refresh data on any change
      },
    );

    _channel!.subscribe();
  }

  Future<void> _fetchLocations() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final data = await supabase
          .from('locations')
          .select()
          .eq('customer_id', userId)
          .order('created_at', ascending: false);

      setState(() {
        locations = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      print('Exception fetching locations: $e');
      setState(() => isLoading = false);
      _showErrorSnackbar('Failed to load locations');
    }
  }

  Future<void> _deleteLocation(int index) async {
    final locationId = locations[index]['location_id'];
    if (locationId == null) return;

    final confirmed = await _showDeleteConfirmation(
      locations[index]['location_name'] ?? 'this location',
    );
    if (!confirmed) return;

    try {
      await supabase.from('locations').delete().eq('location_id', locationId);

      setState(() {
        locations.removeAt(index);
      });

      _showSuccessSnackbar('Location deleted successfully');
    } catch (e) {
      print('Exception deleting location: $e');
      _showErrorSnackbar('Failed to delete location');
    }
  }

  Future<bool> _showDeleteConfirmation(String locationName) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Delete Location'),
                content: Text(
                  'Are you sure you want to delete "$locationName"?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  void _editLocation(int index) async {
    final locationData = locations[index];
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => AddLocationPage(
              initialData: {
                'id': locationData['id'],
                'name': locationData['location_name'],
                'address': locationData['address'],
                'city': locationData['city'],
                'details': locationData['additional_details'],
              },
            ),
      ),
    );
    // Real-time subscription سيحدث القائمة تلقائياً
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Widget _staticLocationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        shadowColor: Color(0xFF563B9C).withOpacity(0.12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: this.iconColor, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.add, color: Colors.grey[400], size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dynamicLocationTile(Map<String, dynamic> location, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.star, color: iconColor, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location['location_name'] ?? 'Unnamed Location',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location['address'] ?? 'No address',
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (location['city'] != null && location['city'].isNotEmpty)
                      Text(
                        location['city'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: iconColor),
                onPressed: () => _editLocation(index),
                tooltip: 'Edit location',
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteLocation(index),
                tooltip: 'Delete location',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Get.back(),
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
          'Saved Locations',
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
      body: RefreshIndicator(
        onRefresh: _fetchLocations,
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 24.0,
                        top: 16.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        'Quick Access',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    _staticLocationTile(
                      icon: Icons.home,
                      title: 'Home',
                      subtitle: 'Add your home address',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => AddLocationPage(
                                  initialData: {'name': 'Home'},
                                ),
                          ),
                        );
                      },
                    ),
                    _staticLocationTile(
                      icon: Icons.work,
                      title: 'Work',
                      subtitle: 'Add your work address',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => AddLocationPage(
                                  initialData: {'name': 'Work'},
                                ),
                          ),
                        );
                      },
                    ),
                    if (locations.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 24.0,
                          top: 24.0,
                          bottom: 8.0,
                        ),
                        child: Text(
                          'Your Saved Places',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ...locations.asMap().entries.map(
                        (entry) => _dynamicLocationTile(entry.value, entry.key),
                      ),
                    ] else if (!isLoading) ...[
                      const SizedBox(height: 40),
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.location_off,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No saved locations yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add your frequently visited places',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          text: '+ Add a location',
          isActive: true,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddLocationPage()),
            );
          },
        ),
      ),
    );
  }
}
