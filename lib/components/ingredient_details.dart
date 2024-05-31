import 'package:flutter/material.dart';
import 'package:reciperescue_client/models/ingredient_model.dart';

class IngredientDetails extends StatelessWidget {
  final Ingredient ingredient;
  final void Function() onDelete;
  final TextEditingController amountController;
  final TextEditingController unitController;

  IngredientDetails({
    Key? key,
    required this.ingredient,
    required this.onDelete,
  })  : amountController =
            TextEditingController(text: ingredient.amount?.toString() ?? ''),
        unitController = TextEditingController(text: ingredient.unit ?? ''),
        super(key: key);

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
            onChanged: (value) {
              ingredient.amount = double.tryParse(value);
            },
          ),
          const SizedBox(height: 8),
          TextField(
            controller: unitController,
            decoration: const InputDecoration(
              labelText: 'Unit',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              ingredient.unit = value;
            },
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
