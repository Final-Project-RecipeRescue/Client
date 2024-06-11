import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String imageUrl;

  const RecipeImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(8.0), // Adjust for desired corner roundness
      child: Image.network(
        imageUrl,
        width: MediaQuery.of(context).size.width,
        height: 150,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
