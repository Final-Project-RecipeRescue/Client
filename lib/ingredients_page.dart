import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/autocomplete_textfield.dart';
import 'controllers/initializer_controller.dart';
import 'models/ingredient_model.dart';

class IngredientsPage extends StatefulWidget {
  @override
  _IngredientsPageState createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  List<IngredientSystem> allIngredients =
      Get.find<InitializerController>().systemIngredients;
  late List<IngredientSystem> filteredIngredients;

  @override
  void initState() {
    super.initState();

    filteredIngredients = allIngredients;
  }

  void _filterIngredients(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredIngredients = allIngredients;
      } else {
        filteredIngredients = allIngredients
            .where((ingredient) =>
                ingredient.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredients Autocomplete'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextfieldAutocomplete<IngredientSystem>(
              items: allIngredients,
              onSubmitted: (ingredient) {
                Get.snackbar('Selected Ingredient', ingredient.name);
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredIngredients.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      filteredIngredients[index].name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
