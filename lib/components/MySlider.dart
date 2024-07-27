// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySlider extends StatefulWidget {
  final String startValue;
  final String endValue;
  final List<dynamic> items;

  const MySlider({
    super.key,
    required this.startValue,
    required this.endValue,
    required this.items,
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
              trackShape: CustomTrackShape(),
              activeTrackColor: Colors.white),
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

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    double additionalActiveTrackHeight = 2.0,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    bool? isEnabled,
    required RenderBox parentBox,
    Offset? secondaryOffset,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required Offset thumbCenter,
  }) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    // Draw the default track first
    super.paint(
      context,
      offset,
      additionalActiveTrackHeight: additionalActiveTrackHeight,
      enableAnimation: enableAnimation,
      isDiscrete: isDiscrete!,
      isEnabled: isEnabled!,
      parentBox: parentBox,
      secondaryOffset: secondaryOffset,
      sliderTheme: sliderTheme,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
    );

    // Draw tick marks
    final double trackHeight = sliderTheme.trackHeight ?? 2.0;
    final double tickMarkRadius = trackHeight * 0.5;
    final double trackLength = parentBox.size.width - offset.dx * 2;

    // Draw the middle tick mark
    final double middleTickX = offset.dx + trackLength * 0.5;
    final Offset middleTickCenter = Offset(middleTickX, thumbCenter.dy);

    canvas.drawCircle(middleTickCenter, tickMarkRadius, paint);
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
