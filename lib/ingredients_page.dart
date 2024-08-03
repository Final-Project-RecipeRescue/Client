import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/components/text_field.dart';
import 'colors/colors.dart';
import 'components/ingredient_card.dart';
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
        title: Text(
          '📋 Ingredients Information',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.normal,
            color: primary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MyTextField(
              hintText: 'Search ingredients',
              onChanged: (value) => _filterIngredients(value),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredIngredients.length,
                itemBuilder: (context, index) {
                  return IngredientCard(ingredient: filteredIngredients[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
