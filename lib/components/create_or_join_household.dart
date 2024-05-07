// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/create_household.dart';

import '../colors/colors.dart';
import '../controllers/household_controller.dart';
import 'custom_button.dart';
import 'new_household.dart';
import 'search_household.dart';

class JoinOrCreateHousehold extends StatefulWidget {
  @override
  _JoinOrCreateHouseholdState createState() => _JoinOrCreateHouseholdState();
}

class _JoinOrCreateHouseholdState extends State<JoinOrCreateHousehold> {
  HouseholdController controller = Get.put(HouseholdController());
  @override
  void initState() {
    super.initState();

    controller.nameNewHousehold.addListener(() {
      controller.updateHouseholdName();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 20, 15, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Do any of your friends or family members already have a household?",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(color: myGrey[900]),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                MyButton(
                  text: 'yes',
                  onPressed: () {
                    setState(() {
                      controller.isJoinExistingHousehold.value = true;
                    });
                  },
                ),
                const Spacer(),
                MyButton(
                  text: 'no',
                  onPressed: () {
                    setState(() {
                      controller.isJoinExistingHousehold.value = false;
                    });
                  },
                )
              ],
            ),
            Obx(
              () => controller.isJoinExistingHousehold.value
                  ? const SearchHousehold()
                  : CreateHousehold(),
            )
          ],
        ),
      ),
    );
  }
}
