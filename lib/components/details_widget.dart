import 'package:clima/utilities/constants.dart';
import 'package:flutter/material.dart';

class Details_widget extends StatelessWidget {
  final String title, value;
  const Details_widget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: kDetailsTextStyle),
            Visibility(
                visible: title == 'WIND' ? true : false,
                child: Text(
                  ' km/hr',
                  style: kDetailsSuffixTextStyle,
                )),
          ],
        ),
        Text(
          title,
          style: kDetailsTitleTextStyle,
        ),
      ],
    );
  }
}
