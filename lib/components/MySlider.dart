import 'package:flutter/material.dart';

class MySlider extends StatefulWidget {
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
      return 'Date Expired';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
        onChangeEnd: (double value) {},
        label: _getLabel(),
      ),
    );
  }
}
