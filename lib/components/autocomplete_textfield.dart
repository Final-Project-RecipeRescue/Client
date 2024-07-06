import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/controllers/initializer_controller.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';
import 'package:reciperescue_client/models/ingredient_model.dart';

class TextfieldAutocomplete<T> extends StatefulWidget {
  final Iterable<Ingredient> items;
  final void Function(Ingredient) onSubmitted;
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
          if (textInput.text.isEmpty) {
            return const Iterable.empty();
          }
          List<String> filteredItems =
              widget.items.map((e) => e.name).where((String item) {
            return item.toLowerCase().contains(textInput.text.toLowerCase());
          }).toList();
          filteredItems.sort((a, b) => a.length.compareTo(b.length));
          return filteredItems;
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextField(
            controller: textEditingController,
            onSubmitted: (value) {
              Ingredient ing =
                  widget.items.firstWhere((element) => element.name == value);
              if (widget.items.contains(ing)) {
                if (T == Ingredient) {
                  widget.onSubmitted(ing);
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
