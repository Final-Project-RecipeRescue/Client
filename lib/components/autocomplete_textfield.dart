import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/controllers/initializer_controller.dart';
import 'package:reciperescue_client/models/ingredient_model.dart';

class TextfieldAutocomplete extends StatelessWidget {
  const TextfieldAutocomplete({super.key});

  @override
  Widget build(BuildContext context) {
    InitializerController controller = Get.find<InitializerController>();
    return Autocomplete<String>(optionsBuilder: (TextEditingValue textInput) {
      if (textInput == "") {
        return const Iterable.empty();
      }
      return controller.systemIngredientsNames.where((String item) {
        return item.contains(textInput.text.toLowerCase());
      });
    });
  }
}
