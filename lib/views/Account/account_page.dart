import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaar/controllers/settings_controllers/account_controller.dart';
import 'package:masaar/controllers/auth_controller.dart';
import 'package:masaar/views/Account/personal_information.dart';
import 'package:masaar/views/Account/saved_locations.dart';
import 'package:masaar/views/Account/wallet_view.dart';
import 'package:masaar/widgets/settings_widgets/settings_items.dart';
import 'package:masaar/widgets/settings_widgets/settings_header.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AccountController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Obx(() {
              final profile = controller.profile.value;

              return Column(
                children: [
                  // Profile Picture + Username
                  Obx(() {
                    final imageFile = controller.selectedImage.value;
                    final imageUrl = controller.profile.value?['profile_image'];

                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          imageFile != null
                              ? FileImage(imageFile)
                              : (imageUrl != null && imageUrl.isNotEmpty)
                              ? NetworkImage(imageUrl) as ImageProvider
                              : const AssetImage(
                                'images/profile_placeholder.png',
                              ),
                    );
                  }),

                  const SizedBox(height: 16),
                  Text(
                    AccountController.getFullName(
                      firstName: controller.firstNameController.text,
                      lastName: controller.lastNameController.text,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Complete your profile',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  const Text(
                    'Add email & photo to get the best experience',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF69696B),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // header
                  const SettingsHeader(title: 'Profile Settings'),
                  SettingsItem(
                    image: Image.asset('images/user.png'),
                    title: 'Personal Information',
                    onTap: () {
                      Get.to(
                        PersonalInformation(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                  ),
                  SettingsItem(
                    image: Image.asset('images/earth.png'),
                    title: 'Language',
                    onTap: () {},
                  ),

                  const SizedBox(height: 10),

                  // header
                  const SettingsHeader(title: 'Payments & Activities'),
                  SettingsItem(
                    image: Image.asset('images/wallet.png'),
                    title: 'Wallet',
                    onTap: () {
                      Get.to(
                        WalletView(
                          firstName: controller.firstNameController.text,
                          lastName: controller.lastNameController.text,
                        ),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                  ),
                  SettingsItem(
                    image: Image.asset('images/location.png'),
                    title: 'Saved Locations',
                    onTap: () {
                      Get.to(
                        SavedLocationsPage(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // header
                  const SettingsHeader(title: 'Account Management'),
                  SettingsItem(
                    image: Image.asset('images/logout.png'),
                    title: 'Log out',
                    onTap: () {
                      final authController = Get.find<AuthController>();
                      authController.signOut();
                    },
                  ),
                  SettingsItem(
                    image: Image.asset('images/delete.png'),
                    title: 'Delete Account',
                    color: const Color(0xFFAC0404),
                    onTap: () {
                      // Implement delete logic later
                    },
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
