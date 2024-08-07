import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:reciperescue_client/components/household_component.dart';
import 'package:reciperescue_client/components/logout_button.dart';
import 'package:reciperescue_client/components/text_field.dart';
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LogoutButton(onLogout: auth.signOut),
          ),
          Spacer(),
          IconButton(
            icon: const Icon(Icons.edit),
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
                    child: Lottie.asset(
                        "assets/images/loading_animation.json")); // Show loading indicator
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

  const EditProfileForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double padding = constraints.maxWidth * 0.05;
        double spacing = constraints.maxHeight * 0.02;

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

  const ProfileImageSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    const defaultImagePath = 'assets/images/logo.png';

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
                        : const AssetImage(defaultImagePath) as ImageProvider,
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

  const PersonalInfoSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    const firstNameLabel = 'First Name';
    const lastNameLabel = 'Last Name';
    const countryLabel = 'Country';
    const stateLabel = 'State';
    const emailLabel = 'Email';

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (controller.isEditMode.value) ...[
              MyTextField(
                controller: controller.firstNameController,
                hintText: firstNameLabel,
              ),
              const SizedBox(height: 16),
              MyTextField(
                controller: controller.lastNameController,
                hintText: lastNameLabel,
              ),
              const SizedBox(height: 16),
              MyTextField(
                controller: controller.countryController,
                hintText: countryLabel,
              ),
              const SizedBox(height: 16),
              MyTextField(
                controller: controller.stateController,
                hintText: stateLabel,
              ),
            ] else ...[
              Text(
                "${controller.user.value.firstName} ${controller.user.value.lastName}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                controller.user.value.email!,
                style: Theme.of(context).textTheme.bodyLarge,
              ), // const SizedBox(height: 16),
              Text(
                "Location: ${controller.user.value.state!},${controller.user.value.country!}",
                style: Theme.of(context).textTheme.bodyLarge,
              ), // MyTextField(hintText: countryLabel, value: controller.country.value),
              const SizedBox(height: 16),
            ],
          ],
        ));
  }
}

class HouseholdsSection extends StatelessWidget {
  final ProfileController controller;

  const HouseholdsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Households:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
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
                    HouseholdComponent(
                        householdName: controller.households[i],
                        onExit: () {
                          controller.removeHousehold(i);
                        })
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        if (controller.isEditMode.value) ...[
          Row(
            children: [
              Expanded(
                child: MyTextField(
                    controller: controller.newHouseholdController,
                    hintText: 'New Household ID'),
              ),
              IconButton(
                icon: const Icon(Icons.add),
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

  const ChangeImageButton({required this.controller});

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
      child: const Text('Change Image'),
    );
  }
}

class SaveButton extends StatelessWidget {
  final ProfileController controller;

  const SaveButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        controller.saveProfile();
        controller.toggleEditMode();
      },
      child: const Text('Save User Data'),
    );
  }
}

class ViewProfile extends StatelessWidget {
  final ProfileController controller;
  final Authenticate auth;

  const ViewProfile({required this.controller, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileImageSection(controller: controller),
            const SizedBox(height: 16),
            PersonalInfoSection(controller: controller),
            const SizedBox(height: 16),
            HouseholdsSection(controller: controller),
            const SizedBox(height: 16),
            // SignOutButton(auth: auth),
          ],
        ),
      ),
    );
  }
}

class SignOutButton extends StatelessWidget {
  final Authenticate auth;

  const SignOutButton({required this.auth});

  @override
  Widget build(BuildContext context) {
    return LogoutButton(
      onLogout: () {
        auth.signOut();
      },
    );
  }
}

// class ShadowedTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;

//   const ShadowedTextField(
//       {super.key, required this.controller, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: MyTextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//           filled: true,
//           fillColor: Colors.white,
//         ),
//       ),
//     );
//   }
// }

// class ShadowedTextBox extends StatelessWidget {
//   final String label;
//   final String value;

//   const ShadowedTextBox({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: TextField(
//         enabled: false,
//         controller: TextEditingController(text: value),
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//           filled: true,
//           fillColor: Colors.white,
//         ),
//       ),
//     );
//   }
// }
