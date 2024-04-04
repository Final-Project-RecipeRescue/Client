import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Recipe extends StatelessWidget {
  const Recipe({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/food_placeholder.png',
            height: 150,
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text('4.5',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            SvgPicture.asset(
              'assets/images/star.svg',
              semanticsLabel: 'star',
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 16),
            Text(
              'Pizza Margaritha',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ]),
        ],
      ),
    );
  }
}
