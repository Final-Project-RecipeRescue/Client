import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/controllers/initializer_controller.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';
import 'package:reciperescue_client/models/ingredient_model.dart';

class TextfieldAutocomplete<T> extends StatefulWidget {
  final Iterable<String> items;
  final void Function(T) onSubmitted;
  const TextfieldAutocomplete(
      {super.key, required this.items, required this.onSubmitted});

  @override
  State<TextfieldAutocomplete<T>> createState() =>
      _TextfieldAutocompleteState<T>();
}

class _TextfieldAutocompleteState<T> extends State<TextfieldAutocomplete<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textInput) {
          if (textInput == "") {
            return const Iterable.empty();
          }
          return widget.items.where((String item) {
            return item.toLowerCase().contains(textInput.text.toLowerCase());
          });
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextField(
            controller: textEditingController,
            onSubmitted: (value) {
              if (widget.items.contains(value)) {
                // Get.find<QuestionnaireController>().addIngredients(value);
                if (T == String) {
                  widget.onSubmitted(value as T);
                } else if (T == Ingredient) {
                  Ingredient ing = Ingredient(
                      ingredientId: '',
                      amount: 1,
                      name: value,
                      purchaseDate: null,
                      unit: null);
                  widget.onSubmitted(ing as T);
                }
                textEditingController.clear();
              }
            },
            focusNode: focusNode,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              border: InputBorder.none,
            ),
            style: const TextStyle(
                decoration: TextDecoration.none), // Remove underline from text
          );
        },
      ),
    );
  }
}
