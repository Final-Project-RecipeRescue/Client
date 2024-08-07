import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/controllers/homepage_controller.dart';
import 'package:reciperescue_client/controllers/profile_controller.dart';
import 'authentication/auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final Authenticate auth = Authenticate();
  final ProfileController controller = Get.put(ProfileController());
  final HomePageController hController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              controller.toggleEditMode();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              if (controller.loading.value) {
                return Center(
                    child:
                        CircularProgressIndicator()); // Show loading indicator
              }
              if (controller.isEditMode.value) {
                return EditProfileForm(controller: controller);
              } else {
                return ViewProfile(controller: controller, auth: auth);
              }
            }),
          );
        },
      ),
    );
  }
}

class EditProfileForm extends StatelessWidget {
  final ProfileController controller;

  EditProfileForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double padding =
            constraints.maxWidth * 0.05; // Adjust padding based on screen width
        double spacing = constraints.maxHeight *
            0.02; // Adjust spacing based on screen height

        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileImageSection(controller: controller),
                  SizedBox(height: spacing),
                  ChangeImageButton(controller: controller),
                  SizedBox(height: spacing),
                  PersonalInfoSection(controller: controller),
                  SizedBox(height: spacing),
                  SaveButton(controller: controller),
                  SizedBox(height: spacing),
                  HouseholdsSection(controller: controller),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfileImageSection extends StatelessWidget {
  final ProfileController controller;

  ProfileImageSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    const defaultImagePath = 'assets/images/user.png';

    return LayoutBuilder(
      builder: (context, constraints) {
        double avatarRadius = constraints.maxWidth * 0.25;
        double iconSize = constraints.maxWidth * 0.08;

        return Obx(() {
          return Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundImage: controller.userImage.value.isNotEmpty
                        ? FileImage(File(controller.userImage.value))
                        : AssetImage(defaultImagePath) as ImageProvider,
                  ),
                  if (controller.isEditMode.value)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.remove_circle,
                            color: Colors.red, size: iconSize),
                        onPressed: () {
                          controller.setUserImage("");
                        },
                      ),
                    ),
                ],
              ),
            ],
          );
        });
      },
    );
  }
}

class PersonalInfoSection extends StatelessWidget {
  final ProfileController controller;

  PersonalInfoSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    final firstNameLabel = 'First Name';
    final lastNameLabel = 'Last Name';
    final countryLabel = 'Country';
    final stateLabel = 'State';
    final emailLabel = 'Email';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (controller.isEditMode.value) ...[
          ShadowedTextField(
              controller: controller.firstNameController,
              label: firstNameLabel),
          SizedBox(height: 16),
          ShadowedTextField(
              controller: controller.lastNameController, label: lastNameLabel),
          SizedBox(height: 16),
          ShadowedTextField(
              controller: controller.countryController, label: countryLabel),
          SizedBox(height: 16),
          ShadowedTextField(
              controller: controller.stateController, label: stateLabel),
        ] else ...[
          ShadowedTextBox(
              label: firstNameLabel, value: controller.firstName.value),
          SizedBox(height: 16),
          ShadowedTextBox(
              label: lastNameLabel, value: controller.lastName.value),
          SizedBox(height: 16),
          ShadowedTextBox(label: emailLabel, value: controller.email.value),
          SizedBox(height: 16),
          ShadowedTextBox(label: countryLabel, value: controller.country.value),
          SizedBox(height: 16),
          ShadowedTextBox(label: stateLabel, value: controller.state.value),
        ],
      ],
    );
  }
}

class HouseholdsSection extends StatelessWidget {
  final ProfileController controller;

  HouseholdsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Households:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Obx(() {
            return SingleChildScrollView(
              child: Column(
                children: [
                  for (var i = 0; i < controller.households.length; i++)
                    ListTile(
                      title: ShadowedTextBox(
                          label: 'Household', value: controller.households[i]),
                      trailing: controller.isEditMode.value
                          ? IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                controller.removeHousehold(i);
                              },
                            )
                          : null,
                    ),
                ],
              ),
            );
          }),
        ),
        SizedBox(height: 16),
        if (controller.isEditMode.value) ...[
          Row(
            children: [
              Expanded(
                child: ShadowedTextField(
                    controller: controller.newHouseholdController,
                    label: 'New Household ID'),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  controller
                      .addHousehold(controller.newHouseholdController.text);
                  controller.newHouseholdController.clear();
                },
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class ChangeImageButton extends StatelessWidget {
  final ProfileController controller;

  ChangeImageButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          controller.setUserImage(pickedFile.path);
        }
      },
      child: Text('Change Image'),
    );
  }
}

class SaveButton extends StatelessWidget {
  final ProfileController controller;

  SaveButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        controller.saveProfile();
        controller.toggleEditMode();
      },
      child: Text('Save User Data'),
    );
  }
}

class ViewProfile extends StatelessWidget {
  final ProfileController controller;
  final Authenticate auth;

  ViewProfile({required this.controller, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileImageSection(controller: controller),
            SizedBox(height: 16),
            PersonalInfoSection(controller: controller),
            SizedBox(height: 16),
            HouseholdsSection(controller: controller),
            SizedBox(height: 16),
            SignOutButton(auth: auth),
          ],
        ),
      ),
    );
  }
}

class SignOutButton extends StatelessWidget {
  final Authenticate auth;

  SignOutButton({required this.auth});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        auth.signOut();
      },
      child: const Text('Sign Out'),
    );
  }
}

class ShadowedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  ShadowedTextField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

class ShadowedTextBox extends StatelessWidget {
  final String label;
  final String value;

  ShadowedTextBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        enabled: false,
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
