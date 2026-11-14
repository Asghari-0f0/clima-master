import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const apiKey = 'd862daf0d9e8eb5d14b7f88a07c8152e';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';
const kLightColor = Colors.white;
const kDarkColor = Colors.white24;
const kMidLightColor = Colors.white60;
const kOverlayColor = Colors.white10;
var kDetailsSuffixTextStyle = GoogleFonts.monda(
  fontSize: 12,
  color: kMidLightColor,
);
var kDetailsTitleTextStyle = GoogleFonts.monda(
  fontSize: 16,
  color: kDarkColor,
);

var kDetailsTextStyle = GoogleFonts.monda(
  fontSize: 20,
  color: kMidLightColor,
  fontWeight: FontWeight.bold,
);
var kTempTextStyle = GoogleFonts.daysOne(
  fontSize: 80,
);
var kLocationTextStyle = GoogleFonts.monda(
  fontSize: 20,
  color: kMidLightColor,
);
const kTextFieldTextStyle = TextStyle(
  fontSize: 16,
  color: kMidLightColor,
);
const kTextFieldDecoration = InputDecoration(
  fillColor: kOverlayColor,
  filled: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide.none,
  ),
  hintText: 'Enter City Name',
  hintStyle: kTextFieldTextStyle,
  prefixIcon: Icon(Icons.search),
);
