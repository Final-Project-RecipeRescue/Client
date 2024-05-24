import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reciperescue_client/controllers/initializer_controller.dart';
import 'package:reciperescue_client/controllers/questionnaire_controller.dart';
import 'package:reciperescue_client/models/ingredient_model.dart';

class TextfieldAutocomplete extends StatefulWidget {
  final Iterable<String> items;
  const TextfieldAutocomplete({super.key, required this.items});

  @override
  State<TextfieldAutocomplete> createState() => _TextfieldAutocompleteState();
}

class _TextfieldAutocompleteState extends State<TextfieldAutocomplete> {
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
                Get.find<QuestionnaireController>().addIngredients(value);
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
// class TextfieldAutocomplete extends StatelessWidget {
//   const TextfieldAutocomplete({super.key});

//   @override
//   Widget build(BuildContext context) {
//     InitializerController controller = Get.find<InitializerController>();
//     Iterable<String> systemIngredientNames =
//         controller.systemIngredients.map((e) => e.name);
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3), // changes position of shadow
//           ),
//         ],
//       ),
//       child: Autocomplete<String>(
//         optionsBuilder: (TextEditingValue textInput) {
//           if (textInput == "") {
//             return const Iterable.empty();
//           }
//           return controller.systemIngredients
//               .map((element) => element.name)
//               .where((String item) {
//             return item.contains(textInput.text.toLowerCase());
//           });
//         },
//         fieldViewBuilder: (BuildContext context,
//             TextEditingController textEditingController,
//             FocusNode focusNode,
//             VoidCallback onFieldSubmitted) {
//           return TextField(
//             controller: textEditingController,
//             onSubmitted: (value) {
//               if (systemIngredientNames.contains(value)) {
//                 Get.find<QuestionnaireController>().addIngredients(value);
//                 textEditingController.clear();
//               }
//             },
//             focusNode: focusNode,
//             decoration: const InputDecoration(
//               contentPadding: EdgeInsets.symmetric(horizontal: 20),
//               border: InputBorder.none,
//             ),
//             style: const TextStyle(
//                 decoration: TextDecoration.none), // Remove underline from text
//           );
//         },
//       ),
//     );
//   }
// }
