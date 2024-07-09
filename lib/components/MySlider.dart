import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reciperescue_client/colors/colors.dart';

class MySlider extends StatefulWidget {
  final String startValue;
  final String endValue;

  const MySlider({
    super.key,
    required this.startValue,
    required this.endValue,
  });

  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  double _currentValue = 1.0;

  String _getLabel() {
    if (_currentValue == 0.0) {
      return 'Pollution';
    } else if (_currentValue == 1.0) {
      return 'Mix';
    } else if (_currentValue == 2.0) {
      return 'Date\nExpired';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.startValue,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 40,
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
              thumbShape: CustomSliderThumbCircle(
                thumbRadius: 30,
                thumbLabel: _getLabel(),
              ),
              trackHeight: 16.0,
              activeTrackColor: primary),
          child: Expanded(
            child: Slider(
              value: _currentValue,
              min: 0.0,
              max: 2.0,
              divisions: 2,
              onChanged: (double value) {
                setState(() {
                  _currentValue = value;
                });
              },
              onChangeEnd: (double value) {
                // TODO send requests to the server for the recipes sorting
              },
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 40,
        ),
        Text(
          widget.endValue,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final String thumbLabel;

  CustomSliderThumbCircle(
      {required this.thumbRadius, required this.thumbLabel});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Paint paint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, thumbRadius, paint);

    final TextSpan span = TextSpan(
      style: GoogleFonts.poppins(
        fontSize: thumbRadius * 0.35,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      text: thumbLabel,
    );

    final TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: textDirection,
    );

    tp.layout();
    tp.paint(
      canvas,
      center - Offset(tp.width / 2, tp.height / 2),
    );
  }
}
