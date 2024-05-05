import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/models/recipes_ui_model.dart';
import 'package:transparent_image/transparent_image.dart';

class Recipe extends StatelessWidget {
  final RecipesUiModel recipeModel;
  const Recipe({required this.recipeModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/food_placeholder.png',
                image: recipeModel.image_url,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4,
                fit: BoxFit.fill,
              )),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  recipeModel.likes.toString(),
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  'assets/images/star.svg',
                  semanticsLabel: 'star',
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  // Place Expanded here to allow the Text to expand
                  child: Text(
                    recipeModel.title,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
