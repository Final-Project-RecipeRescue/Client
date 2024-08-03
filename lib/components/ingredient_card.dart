import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

import '../colors/colors.dart';
import '../models/ingredient_model.dart';

class IngredientCard extends StatelessWidget {
  final IngredientSystem ingredient;

  const IngredientCard({Key? key, required this.ingredient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    ingredient.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${ingredient.sumGasPollution} gCO2',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Expires in ${ingredient.daysToExpire} days',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Emoji on the right side
            Text(
              getEmojiByName(ingredient.name),
              style: const TextStyle(
                fontSize: 48, // Larger font size for the emoji
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getEmojiByName(String name) {
    EmojiParser parser = EmojiParser();
    List<String> words = name.split(' ');

    for (String word in words) {
      Emoji emoji = parser.info(word.toLowerCase());
      if (emoji != Emoji.None) {
        return emoji.code;
      }
    }

    return '🍽';
  }
}
