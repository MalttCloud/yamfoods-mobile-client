import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  //app
  static const Color primary = Color(0xFF0A2447); // Color(0xFF64390C);
  static const Color primaryLight = Color(
    0xFF8B5A2B,
  ); // Lighter shade for gradient
  static const Color secondary = Color(0xCC553412);
  static const Color background = Color(0xFFFFF9ED);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;

  //text
  static const Color txtPrimary = primary;
  static const Color txtSecondary = secondary;

  //button
  static const Color btnPrimary = primary;
  static const Color btnSecondary = Color(0xFFF5F5F5);

  //status
  static const success = Color(0xFF059669);
  static const warning = Color(0xFFF59E0B);
  static const error = Color.fromARGB(255, 245, 120, 120);
  static const info = Color(0xFF2563EB);
  static const lightRed = Color.fromARGB(
    255,
    240,
    105,
    105,
  ); // Red color for logout actions

  // Branch card colors
  static const cardGradientStart = primary;
  static const cardGradientMid = Color(0xFF64390C); // primary with alpha
  static const cardGradientEnd = secondary;
  static const cardShadow = Color(0xFF64390C); // primary for shadow
  static const cardTextWhite = white;
  static const cardTextWhiteDimmed = Color(0xFFFFFFFF); // white with alpha
  static const cardBackgroundCircle = Color(0xFFFFFFFF); // white with alpha

  static const Color accentOrange = Color(0xFFffaa00);
}
