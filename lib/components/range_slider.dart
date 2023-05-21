import 'package:flutter/material.dart';

import '../config/config.dart';

class IntRangeSlider extends StatefulWidget {
  const IntRangeSlider(
      {super.key,
      required this.min,
      required this.max,
        this.divisions,
      required this.rangeNotifier});

  final int min;
  final int max;
  final ValueNotifier<RangeValues> rangeNotifier;
  final int? divisions;

  @override
  State<IntRangeSlider> createState() => _IntRangeSliderState();
}

class _IntRangeSliderState extends State<IntRangeSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RangeSlider(
          values: widget.rangeNotifier.value,
          max: widget.max.toDouble(),
          min: widget.min.toDouble(),
          divisions: widget.divisions?? widget.max - widget.min,
          labels: RangeLabels(
            widget.rangeNotifier.value.start.round().toString(),
            widget.rangeNotifier.value.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              widget.rangeNotifier.value = values;
            });
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Config.defaultPadding * 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Config.defaultText(widget.min.toString()),
              Config.defaultText(widget.max.toString()),
            ],
          ),
        )
      ],
    );
  }
}
