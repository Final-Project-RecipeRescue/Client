import 'package:flutter/material.dart';
import 'package:reciperescue_client/colors/colors.dart';

class HouseholdComponent extends StatelessWidget {
  final String householdName;
  final void Function() onExit;

  HouseholdComponent({required this.householdName, required this.onExit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: primary, // Background color of the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4.0, // Adds shadow to the card
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      householdName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              // Emoji on the right side
              IconButton(
                icon: Icon(Icons.hail_rounded),
                onPressed: onExit,
              ),
            ],
          ),
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Text(
    //         householdName,
    //         style: Theme.of(context).textTheme.bodyMedium,
    //       ),
    //       IconButton(
    //         icon: Icon(Icons.hail_rounded),
    //         onPressed: onExit,
    //       ),
    //     ],
    //   ),
    // );
  }
}
