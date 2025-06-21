import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaar/controllers/settings_controllers/account_controller.dart';
import 'package:masaar/widgets/custom%20widgets/custom_button.dart';

class PersonalInformation extends StatelessWidget {
  PersonalInformation({Key? key}) : super(key: key);

  final AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    if (accountController.profile.value == null) {
      accountController.loadUserProfile();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          'Personal Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Obx(() {
          if (accountController.profile.value == null) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      InkWell(
                        onTap: () async {
                          await accountController.pickAndUploadImage();
                        },
                        child: Obx(() {
                          final imageFile =
                              accountController.selectedImage.value;
                          final imageUrl =
                              accountController.profile.value?['profile_image'];

                          return CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                imageFile != null
                                    ? FileImage(imageFile)
                                    : (imageUrl != null && imageUrl.isNotEmpty)
                                    ? NetworkImage(imageUrl) as ImageProvider
                                    : AssetImage(
                                      'assets/images/profile_upload.png',
                                    ),
                          );
                        }),
                      ),

                      const SizedBox(height: 12),
                      const Text(
                        'Add a profile picture so drivers can recognize you',
                        style: TextStyle(
                          color: Color(0xFF919191),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: accountController.firstNameController,
                              decoration: const InputDecoration(
                                labelText: 'First name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: accountController.lastNameController,
                              decoration: const InputDecoration(
                                labelText: 'Last name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: accountController.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: accountController.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'username@example.com',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  text: 'Save changes',
                  onPressed: () async {
                    if (accountController.firstNameController.text.isEmpty ||
                        accountController.emailController.text.isEmpty) {
                      Get.snackbar('Error', 'Please fill all required fields');
                      return;
                    }

                    await accountController.updateProfile();
                    Get.snackbar(
                      'Success',
                      'Profile updated successfully',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  isActive: true,
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        }),
      ),
    );
  }
}
