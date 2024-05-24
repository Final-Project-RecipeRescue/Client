import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reciperescue_client/models/ingredient_model.dart';

class IngredientDetails extends StatelessWidget {
  Ingredient ingredient;
  void Function() onDelete;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController unitController = TextEditingController();

  IngredientDetails(
      {super.key, required this.ingredient, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ingredient.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: amountController,
            decoration: const InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: unitController,
            decoration: const InputDecoration(
              labelText: 'Unit',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          // Center(
          //   child: GestureDetector(
          //     onTap: onDelete,
          //     child: const Icon(
          //       Icons.delete,
          //       color: Colors.red,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
